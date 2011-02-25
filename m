Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab1BYFLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 00:11:32 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51433 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab1BYFLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 00:11:30 -0500
Date: Fri, 25 Feb 2011 16:11:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: linux-next: manual merge of the tty tree with Linus' tree
Message-Id: <20110225161124.665ac4e9.sfr@canb.auug.org.au>
In-Reply-To: <20110224193947.GA15044@kroah.com>
References: <20110224163439.05352f9b.sfr@canb.auug.org.au>
	<20110224193947.GA15044@kroah.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__25_Feb_2011_16_11_24_+1100_D2xPZJcQWjRKnH8C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Feb_2011_16_11_24_+1100_D2xPZJcQWjRKnH8C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 24 Feb 2011 11:39:47 -0800 Greg KH <greg@kroah.com> wrote:
>
> Thanks, I've merge 2.6.38-rc6 into tty-next so this, and another merge
> issue, should now be resolved.

Thanks.  The tree still has its build failure, though.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Feb_2011_16_11_24_+1100_D2xPZJcQWjRKnH8C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNZzn8AAoJEDMEi1NhKgbsqTQH/2XcNfkUp7uXzThREWqDJ7SU
NLrlXKxRNRNR0B7AET/WGb3iryS+uKJWHZK/ZioeXP3RTF+VLQFykDINcd+8tw9E
mNPZrBHsYpo78LmM/kBKyMCcCFwKPxMmqRhbKTyA9VmdPj7sZxZIbAuajN3WhuK9
LYvq+rflAP7W0SpPPH+vlm3qLA4wCB41c7+8Ut0KT67Vn0vbqkR005T5x8n00bIt
mCRmBsp4dj70tPEmKSnLzJcLjyvU7dgORCog7+BC9jufrXd5PkdLXNC+QiYqKYl6
8fpI2AsuJjy7U3dIHpFp3lZyVzDcsOP2CznlpdfvoTfQIsyAt57+ChYXW80ailo=
=47pV
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Feb_2011_16_11_24_+1100_D2xPZJcQWjRKnH8C--
