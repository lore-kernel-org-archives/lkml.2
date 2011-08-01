Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab1HAKH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:07:28 -0400
Received: from narfation.org ([79.140.41.39]:49554 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab1HAKHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:07:23 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: Re: [PATCHv4 05/11] omap3isp: Use *_dec_not_zero instead of *_add_unless
Date: Mon, 01 Aug 2011 12:07:15 +0200
Message-ID: <1518031.UNu44UiQdf@sven-laptop.home.narfation.org>
User-Agent: KMail/4.6.0 (Linux/2.6.39-2-686-pae; KDE/4.6.5; i686; ; )
In-Reply-To: <201107311700.43515.laurent.pinchart@ideasonboard.com>
References: <1311760070-21532-1-git-send-email-sven@narfation.org> <1311760070-21532-5-git-send-email-sven@narfation.org> <201107311700.43515.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1410967.cpOlAuVVht"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1410967.cpOlAuVVht
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sunday 31 July 2011 17:00:43 Laurent Pinchart wrote:
> Hi Sven,
> 
> Thanks for the patch.
> 
> On Wednesday 27 July 2011 11:47:44 Sven Eckelmann wrote:
> > atomic_dec_not_zero is defined for each architecture through
> > <linux/atomic.h> to provide the functionality of
> > atomic_add_unless(x, -1, 0).
> > 
> > Signed-off-by: Sven Eckelmann <sven@narfation.org>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I'll queue this to my tree for v3.2. Please let me know if you would rather
> push the patch through another tree.

The problem is that until now no one from linux-arch has applied the patch 
01/11 in his tree (which is needed before this patch can be applied) and you 
tree have to be based on the "yet to be chosen linux-arch tree". Otherwise 
your tree will just break and not be acceptable for a pull request. 

Maybe it is easier when one person applies 01-11 after 02-11 was Acked-by the 
responsible maintainers.

02 is more or less automatically Acked-by us :)
04, 09 and 10 are also Acked.
... and the rest is waiting for actions.

Kind regards,
	Sven
--nextPart1410967.cpOlAuVVht
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCgAGBQJONnrTAAoJEF2HCgfBJntGlHgQALreUYVAb04uP6ya4Mz0D24D
9gRxde9DaBYZovxlmhH9Cis/FiOEGkpbMl/sooyRZYzWaID5jpDp8020K622uBMw
Le3CrZOzv1IZtEFepJ1jxaRUOgNHVACwH0+B314BNNhRG3NZet1MRMhpwWYWbVQ9
SupB7fB7GNn23a0nkvwFndRxAONpbWMc4rtSbZMwi4x4ViSRVlFkAxGefLubBUoJ
/0J8hX6C/ddrYbuJWdHbzlFr2y/j3S8EQFV0YTBGOeLjBAN/io3K/t76IEFCuofP
47wmjKLgkl0EJIYQw8Rzhqd6tzPupXTPgeJfi0jwQvBCUValXO34rDf+2iZoB1eo
fdNBnvYTZWpM3DDDtJtEnNN9/1V0P4qnYuvwxhDD8d2w1PHh8TlSpug72oliKnm+
Y+XC+E2jZFGuQDofZqu/SCpFqsesjyRJVvEMXbk4pxT1AyVlWELgdnxcFg5zqPxG
UFk38o5mp4yqm18KWQDqmH4LNjBlP00SSl8wyMYUfiowc81Yt5gf/T6gViDM7o74
RCmfuzRKd8uyrKeeVakEEWMv5f2oVRZy0ziBT3R4wo8NBsErQR//6L0d8RvdWM0L
0MnlpHBbw88pFJDcLL8HnloF7hO3914WwPcbIQ3M1A6WSLFEzhcjuuIrckHE2nae
+ihdk+MrfXO8JKC0rmH/
=NHxW
-----END PGP SIGNATURE-----

--nextPart1410967.cpOlAuVVht--

