Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1LIBv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 20:51:26 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:50912 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1LIBvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 20:51:24 -0500
Date: Fri, 9 Dec 2011 12:51:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Boyer <jwboyer@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: linux-next: manual merge of the 4xx tree with the powerpc tree
Message-Id: <20111209125116.f8a5d071c3e86d26c7f8660e@canb.auug.org.au>
In-Reply-To: <CA+5PVA5vVC=e24imM0QxbT10kBAF4v=kwheKs7cOHKKcC+if=A@mail.gmail.com>
References: <20111209123811.12cf28971f21a309976f31bb@canb.auug.org.au>
	<CA+5PVA5vVC=e24imM0QxbT10kBAF4v=kwheKs7cOHKKcC+if=A@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Dec_2011_12_51_16_+1100_=KHtd8zT5SYgbZS."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Dec_2011_12_51_16_+1100_=KHtd8zT5SYgbZS.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Josh,

On Thu, 8 Dec 2011 20:46:39 -0500 Josh Boyer <jwboyer@gmail.com> wrote:
>
> I blame BenH.  I sent him a pull request with d5b9ee7b514e in it
> before he went and updated his tree.  Still not pulled afaik.  Guess
> I'll be rebasing my next branch tomorrow to pick up a series from Tony
> Breeds, unless Ben handles the outstanding pull before I wake up :).

Don't bother rebasing, let Ben handle the conflict in the merge.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Dec_2011_12_51_16_+1100_=KHtd8zT5SYgbZS.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO4WmUAAoJEECxmPOUX5FEiXEP/iKMXQUoiEyDQH1457TWkCBL
O+h0km6lcJGrHCaNIVCJqXWZSsJbSYLa5yWxNuQabkoc1M6mpH311jShqbCnDlSl
NcgCsJMSKKU667fzoxbaj1tSvYPQnODihqWY4Yr5wYCkG3t6O0H14oOHjJv5cuLu
oMNcbSlR2UkazZKFLACOSqqmX6Ex1L8UaA9dawVC3eNIVHpfJ6T5MpiHkYOkkLSx
6ZXkV3DoAmrbhcCJn4jLaXK/TIceJFGk5wv9WblXKwxHhZOX+8cUaBtWTUKqye2p
eU/6X1VKv6aHVqwQGIy5gmbpctNf8ZvPu4xiqka56REcD7G6A01p+2KzoaMgFB8Z
7NXuZsVhUu+5KNjQuezYOzauKcyzEGB7f7j/T2bTS4rEenMOR7fC1H2h4M3F2vd4
EGjAQBT6e72bTw0y3vZgQuwqaG9NpQsgIccVO3rOvfz6LMsIgsho7R4ne368ORw+
Pp7H9ksCBSbAP2osQwOwRrAyyfhu88r+EScDjuXhNsjGgrBBzNZ86BkhH5lKuQ1P
WezaK8aI5ThVzD4p+x2PapBubBkkhpYBYRgoEaxnMYcZVlalgh7UuArxViL0Qi0o
a6n7xMyMlvOcjRzDa/RzYD6VSPeNkmhJVik0qQogHZEl679qD5e9xbtBiygtL8GI
O0lPGNXT050P7RRkkux1
=QTCy
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Dec_2011_12_51_16_+1100_=KHtd8zT5SYgbZS.--
