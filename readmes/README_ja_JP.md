
# yumrepo_core

#### 目次

1. [説明](#description)
2. [セットアップ - yumrepo_coreモジュール導入の基本](#setup)
    * [yumrepo_coreモジュールの利用方法](#beginning-with-yumrepo_core)
3. [使用 - 設定オプションと追加機能](#usage)
4. [開発 - モジュール貢献についてのガイド](#development)

<a id="description"></a>

## 説明

yumrepo_coreモジュールは、INI設定ファイルの構文解析によるクライアントのyumリポジトリ設定の管理に使用されます。

<a id="setup"></a>

## セットアップ

<a id="beginning-with-yumrepo_core"></a>
                                    
### yumrepo_coreモジュールの利用方法

ローカルミラー使用時にPuppet Labs製品のyumリポジトリを管理するには、以下のコードを使用します。

```
yumrepo { 'puppetrepo-products':
  ensure    => 'present',
  name      => 'puppetrepo-products',
  descr     => 'Puppet Labs Products El 7 - $basearch',
  baseurl   => 'http://myownmirror',
  gpgkey    => 'http://myownmirror',
  enabled   => '1',
  gpgcheck  => '1',
  target    => '/etc/yum.repo.d/puppetlabs.repo',
}

```

<a id="usage"></a>

## 使用

利用方法の詳細については、[yumrepo puppetドキュメント](https://puppet.com/docs/puppet/latest/types/yumrepo.html)を参照してください。

## リファレンス

リファレンス文書については、REFERENCE.mdを参照してください。

このモジュールは、Puppet Stringsを用いて文書化されています。

Stringsの仕組みの簡単な概要については、Puppet Stringsに関する[こちらのブログ記事](https://puppet.com/blog/using-puppet-strings-generate-great-documentation-puppet-modules)または[README.md](https://github.com/puppetlabs/puppet-strings/blob/master/README.md)を参照してください。

文書をローカルで作成するには、以下のコマンドを実行します。
```
bundle install
bundle exec puppet strings generate ./lib/**/*.rb
```
このコマンドにより、閲覧可能な`_index.html`ファイルが`doc`ディレクトリに作成されます。ここで利用可能なリファレンスはすべて、コードベースに埋め込まれたYARD形式のコメントから生成されます。このモジュールに関して何らかの開発をする場合は、影響を受ける文書も更新する必要があります。

<a id="development"></a>

## 開発

Puppet ForgeのPuppet Labsモジュールは、オープンプロジェクトです。プロジェクトをさらに発展させるには、コミュニティへの貢献が不可欠です。Puppetが役立つ可能性のある膨大な数のプラットフォーム、無数のハードウェア、ソフトウェア、デプロイメント構成に我々がアクセスすることはできません。

弊社は、できるだけ変更に貢献しやすくして、弊社のモジュールがユーザの環境で機能する状態を維持したいと考えています。弊社では、状況を把握できるよう、貢献者に従っていただくべきいくつかのガイドラインを設けています。

詳細については、[モジュール貢献ガイド](https://docs.puppetlabs.com/forge/contributing.html)を参照してください。
