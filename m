Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab0HEPpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:45:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52607 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758868Ab0HEPpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:45:03 -0400
Date: Fri, 6 Aug 2010 01:44:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: gregkh@suse.de, linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] powerpc: implement arch_setup_pdev_archdata
Message-Id: <20100806014455.8cab0ae9.sfr@canb.auug.org.au>
In-Reply-To: <1281021347-1278-3-git-send-email-galak@kernel.crashing.org>
References: <1281021347-1278-1-git-send-email-galak@kernel.crashing.org>
	<1281021347-1278-2-git-send-email-galak@kernel.crashing.org>
	<1281021347-1278-3-git-send-email-galak@kernel.crashing.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Aug_2010_01_44_55_+1000_hnIP.UmW4aU7nLCJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Aug_2010_01_44_55_+1000_hnIP.UmW4aU7nLCJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kumar,

On Thu,  5 Aug 2010 10:15:46 -0500 Kumar Gala <galak@kernel.crashing.org> w=
rote:
>
> +static inline void arch_setup_pdev_archdata(struct platform_device *pdev)
> +{
> +	pdev->dev.dma_mask =3D &pdev->archdata.dma_mask;
> +
> +	return;
> +}

The blank line and "return;" don't add anything.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Aug_2010_01_44_55_+1000_hnIP.UmW4aU7nLCJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMWtx3AAoJEDMEi1NhKgbs7A8H/1w1Mq/Mdc79FJfi7XESRsZ8
eY7Fn4wcj1c9hdU4LLBkXEWMpFU2mc+sb3lFL6vsxyei1zg+mK8elF07BrpiTfmm
E61tEZ/0+WjBFUQGtoEpXwtQG0j25jr08BMzrfvTrXtCNp54xYZ2kPc2KqqQOw08
M88yAIqR9KZS1zN3KYkjXlRcE2vOIknIPW943b1Nd48LDzsw7I+1R/Jm0OucmrMI
eH44mDSENzH3J7TLmv3nR9YZnocYMep0r7wDl0JLTbayiDr58WzVMZFdvFDgQFZp
QeZxVokrpTB1RZ7dpwXV0RuppejR9/TR2ZF7UAS3TAmMqyYMSjBwVZV+EZzhXh0=
=cqsU
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Aug_2010_01_44_55_+1000_hnIP.UmW4aU7nLCJ--
