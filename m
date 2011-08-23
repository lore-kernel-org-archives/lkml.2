Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1HWFsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 01:48:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53270 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab1HWFsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 01:48:19 -0400
Date: Tue, 23 Aug 2011 15:48:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20110823154811.527ae4929dd2078e694fe32a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Aug_2011_15_48_11_+1000_Yy+Z5gcIT2QjNiAJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Aug_2011_15_48_11_+1000_Yy+Z5gcIT2QjNiAJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) failed like this:

kernel/cred.c: In function 'prepare_kernel_cred':
kernel/cred.c:657:2: error: 'tgcred' undeclared (first use in this function)

Caused by commit 012146d0728f ("CRED: Fix prepare_kernel_cred() to
provide a new thread_group_cred struct").  CONFIG_KEYS is not set in this
build ...

Please, please build test with and without CONFIG settings that affect
your changes.

I discovered this after releaseing linux-next for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Aug_2011_15_48_11_+1000_Yy+Z5gcIT2QjNiAJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOUz8bAAoJEDMEi1NhKgbs1ZsIAJsppXB3gAwcXfgTAno71/vI
ewpR57k5a2EcDer4/PMmXz4YbEOoaWAwS5ys6W/I717G7DQyAFMEIBJsjtUxOMry
r+4JX4bpyoT7TKbkvVZ5063eIsQi2Zincw1FyRNpeYtLGRePtZYwfUE0LfBBM79E
0u+9bIW5WmtZQdxLB7Ej4Y7ctVNvnKQKm+swHx7TD48YHu/8iuLdulnH1513Tu2Z
iFSl31pT2LUEPzWzh9lndQ8DzVYEf9tH+Ejg8aGbpcqTNaBge7m2QS4SvaEYVKVp
GM06GRHA5TZzJ+m/HC1MoDUC73jqHbN7iETfJgCvf6dOmwpyXBC/12FcOxY5QaQ=
=fpa8
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Aug_2011_15_48_11_+1000_Yy+Z5gcIT2QjNiAJ--
