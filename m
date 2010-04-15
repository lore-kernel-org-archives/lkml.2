Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab0DOGQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:16:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52244 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423Ab0DOGQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:16:45 -0400
Date: Thu, 15 Apr 2010 16:16:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Divyesh Shah <dpshah@google.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: linux-next: build failure after merge of the block tree
Message-Id: <20100415161633.a7950127.sfr@canb.auug.org.au>
In-Reply-To: <r2kaf41c7c41004142223m1464fd07u5617fe7332cb2ea@mail.gmail.com>
References: <20100415124222.8e0e7132.sfr@canb.auug.org.au>
	<r2kaf41c7c41004142223m1464fd07u5617fe7332cb2ea@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_Apr_2010_16_16_33_+1000_ewFSoxtuYBNq+MTA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Apr_2010_16_16_33_+1000_ewFSoxtuYBNq+MTA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Divyesh,

On Wed, 14 Apr 2010 22:23:25 -0700 Divyesh Shah <dpshah@google.com> wrote:
>
>      These errors seem to show up because the 2 symbols aren't
> exported and hence when building as a module we don't have access to
> these symbols. I'll send a patch to fix that shortly. Sorry for the
> build breakage.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Apr_2010_16_16_33_+1000_ewFSoxtuYBNq+MTA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvGr0EACgkQjjKRsyhoI8x7hgCfXFFXPpwFu1OObCHdULw/lzar
ZWcAn2qmNnc4qNjcnjGQfvYiu7UJch+s
=mhlk
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Apr_2010_16_16_33_+1000_ewFSoxtuYBNq+MTA--
