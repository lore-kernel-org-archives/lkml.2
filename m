Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab2G0AXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 20:23:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59260 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2G0AXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 20:23:50 -0400
Date: Fri, 27 Jul 2012 10:23:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Block <ablock84@googlemail.com>,
        David Sterba <dave@jikos.cz>, Arne Jansen <sensille@gmx.net>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>,
        Alex Lyakas <alex.bolshoy.btrfs@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: linux-next: build failure in Linus' tree
Message-Id: <20120727102348.d50d3c9e8cd5d7cae6603737@canb.auug.org.au>
In-Reply-To: <20120727101535.aa873d14cd8a6736413e9cea@canb.auug.org.au>
References: <20120727101535.aa873d14cd8a6736413e9cea@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Jul_2012_10_23_48_+1000_jEMaofK1c9Z+F/KD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Jul_2012_10_23_48_+1000_jEMaofK1c9Z+F/KD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Jul 2012 10:15:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 27 Jul 2012 10:11:13 +1000
> Subject: [PATCH] Btrfs: using vrmzalloc and friends needs vmalloc.h

That should say "vmalloc". of course.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__27_Jul_2012_10_23_48_+1000_jEMaofK1c9Z+F/KD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQEd+UAAoJEECxmPOUX5FEVvkP/2hMG/+t+0XRn+nkCrBan73c
7/EMgpfMLlGBrVxW/Ol5xrlRwGAYbXwKqGAbZf5/N3BkQQM8p9Rro0socvn3FgqA
jdzC3sqmsj4kQ32Nznf1PbJOn9bqx+dluvJQTng+jhWFmMOyG+pWADswKXOq/3cW
OmQ+2NO5xw+LAI1qpYV/dmPEBndHoUQ2w56U5WbPutArrEGP45McrTqIy1TuszGw
YFldLvlpNd18FVPJ6+0RltmCg/32KfDrMUizAP9EyHlO7X7/HtePwIxO8elbj9yR
pVSc22Gig4KAwu7MFtdyqoJt/GdDA14BH3swzT9w47no5zPQQwqTKFa6PsND20Gg
KD4BI+6sqtMk3b3RbiU1RbqkqcsxCDHtxiluWIYNvp5Dr4ueOlrDrEqjgfm9TW5b
2VQhEXeRawgabZHVLYwyJoIh1GXa+dB5e8MTmQ3gIy24QodJj0GWE4enYqJpli/o
hhe87mLVbySs/1WBnzFRwGwH0E8jnpr6IT91gFjGbckL5SDNr5j5oaqQYhC5WEeJ
APeBjh8VA+7bu4AJo1hWQU2uQ8N5sUctS/iZdsxhrAAphY+fsJqLv9vJsF1ilGjl
T5QqIMicrwi8CLhQSuH/yyArbI6edTw08TXg2Qa7FVX0jekgrfh4xw/UfAKmnOcQ
uwl1eIRs3ZdaDOANbBcf
=mgZH
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Jul_2012_10_23_48_+1000_jEMaofK1c9Z+F/KD--
