Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab2HPLO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:14:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49934 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab2HPLOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:14:55 -0400
Date: Thu, 16 Aug 2012 21:14:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (hid
 tree related)
Message-Id: <20120816211435.24709c08df98abbd016e2c5f@canb.auug.org.au>
In-Reply-To: <alpine.LNX.2.00.1208161204520.7026@pobox.suse.cz>
References: <20120816152538.7f850ee1a3b8ce90d9f749a2@canb.auug.org.au>
	<alpine.LNX.2.00.1208161204520.7026@pobox.suse.cz>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Aug_2012_21_14_35_+1000_AOaR1yGxmCVPoFIi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Aug_2012_21_14_35_+1000_AOaR1yGxmCVPoFIi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

On Thu, 16 Aug 2012 12:05:57 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wro=
te:
>
> Hmm, seems config dependent, doesn't trigger here. Probably vmalloc.h get=
s=20
> sucked in some other way under certain config options.

That's why we have Rule 1 in Documentation/SubmitChecklist.

> Anyway I have now applied your patch Stephen, so you should be able to=20
> drop it from your pile.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__16_Aug_2012_21_14_35_+1000_AOaR1yGxmCVPoFIi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQLNYbAAoJEECxmPOUX5FE6voP/AjgT8r4dLOtyJsXRgjLVL8C
GCqnORpUaEOEK8iuAQA5cMLuIeoMXpI143S4HRBjOgBHQ5sJbriqM+SIzVS6/a0T
4fsL9g4AVJnGmyChX0g25tI9ckq8jUildr3K1lTHj07NZrXYNwnvSgS5sSB8O/HW
/1rWMJ6lHLQe1I1EFimLSVvm3pKgHL7xAEWPURcGN1W25hTQszFt88V3GiKS1nYp
KTJHIV81W7pxW7l54h1YBBUrlBrECKi4K6JywM8EE5xEtzIk/eEpe0cJSdnHYmJd
QKs5uRtuPP1DZaEyfDEWVrgb1qUoB/lNA9u69Xh8uk4IO4uSp7mmN09iodYuSr17
dcMRBK7NhiVjVQq6BZP9ZsLYSRgQ1JHsuxn6tCe4hNbeENIZSZnja16ru36krzqo
MZp0l8jBCGnPqW1sPRfaFE82dt8Dzen0mjE97YOuJ2Jh8wXCQspV7kkBHI01DSQU
/R3XobuLRk8/LcqvVctNmurcPU/iS2dWJ0yHYHMOwvibBsGDawjbsWaZwQT69W/T
VmJJQmjpHT5z2QkWwkKtn+B1ORV7x3oEOOb1COeaoala7Q6bzd2yI4WNHtkIJ+DJ
D1QBHu8sgaS086n3SWuTvEoWcEETeWDG2M8O2yhdmGVvZgw5TPGA5BCfCITeXViT
ib2LUT74onGCcceY/ipB
=lX2C
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Aug_2012_21_14_35_+1000_AOaR1yGxmCVPoFIi--
