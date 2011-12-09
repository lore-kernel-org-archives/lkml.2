Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1LILMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 06:12:00 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:45525 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab1LILL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 06:11:58 -0500
Date: Fri, 9 Dec 2011 22:11:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the arm-lpae tree with the arm tree
Message-Id: <20111209221147.01607dbecde64cfc7baaef28@canb.auug.org.au>
In-Reply-To: <20111209103652.GA23753@arm.com>
References: <20111208110059.1d88730db9358e079949b89c@canb.auug.org.au>
	<20111209103652.GA23753@arm.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Dec_2011_22_11_47_+1100_MPif7L6UkWz+x/eR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Dec_2011_22_11_47_+1100_MPif7L6UkWz+x/eR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

On Fri, 9 Dec 2011 10:36:52 +0000 Catalin Marinas <catalin.marinas@arm.com>=
 wrote:
>
> The fix looks correct but Russell merged the LPAE patches into his tree
> last night and sorted out the conflicts, so you can now drop my for-next
> branch from -next (I'll still keep the kmemleak one).

OK, will do.  Thanks for letting me know.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Dec_2011_22_11_47_+1100_MPif7L6UkWz+x/eR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO4ezzAAoJEECxmPOUX5FECwwQAKSZG5U1ApMMmmIQ1kQ6IEDa
h5Tn8MD0wg108LDYQZ5JyRAtl5TX489BX20q/25TpE8Q9gv7JBtxm8JDw9SBlc8e
J8oRyra/Gzq2Fzf/4maAao6tMJs3OXEEiCAqHjk8pdQNlgnysaQTnunenESXvlDm
0N1yCTrrfMZCEUMFMaJL97hEvW7I1fMyVeepIlHIGvC7K68nwSlvj4JeYCmrqMLR
QcJRIWT1/9JP8GTRTzM9Y881edR+Iyglzh1EVsfznQk7wXfnFwWv2xpfV31fALrN
rmG0uJnMfFHtkAEN3Cp951kGnyWJCLjnVr0Ld16Hd2iigUtmaYj6IJPCs/+aITmy
a7vklAF/z7asq69xkxwVhNin/Wudxpljlz6BerkxQOSsERal9hoT30l1bw/7LKU6
iVUx0JQaMeC4GXYUc1hWCCrglMAE0AkcHPR21y7Ykklqomdy4/7czhZiR/1eLigB
P0fpWL0N4zii5jn0FNnBizz45AZBXuLb18dKFXmbvceXnJY4lmeE2IJ6QChKX0gl
VI+fUF3L4zJaJrVmw4W+LJmnlecCRzvy4/ZLR6jvk2Lz+7Wpii1f/YkelDEJ1RHE
8Vg9P7I84/P+tL6n/NY3Rhq0ebP9QLlUbnF6zI8LTqy4o9wz/2oldbcIGNU82epO
522OF2/9shPwgwdiAyOL
=Hvjb
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Dec_2011_22_11_47_+1100_MPif7L6UkWz+x/eR--
