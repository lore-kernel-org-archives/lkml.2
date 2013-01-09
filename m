Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab3AJAEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 19:04:47 -0500
Received: from scrye.com ([75.148.32.185]:36135 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758148Ab3AJAEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 19:04:46 -0500
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2013 19:04:46 EST
Date: Wed, 9 Jan 2013 16:58:07 -0700
From: Kevin Fenzi <kevin@scrye.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ALSA: Conexant CX20585 (thinkpad t510) speaker powersave
 regression
Message-ID: <20130109165807.11a07af0@jelerak.scrye.com>
In-Reply-To: <s5hk3rnofv5.wl%tiwai@suse.de>
References: <20121222142324.73586307@jelerak.scrye.com>
	<s5hk3rnofv5.wl%tiwai@suse.de>
Organization: Scrye, INC
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lVz734TR50=k5IpX25wU2gy"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lVz734TR50=k5IpX25wU2gy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 08 Jan 2013 16:26:38 +0100
Takashi Iwai <tiwai@suse.de> wrote:

> It's a known problem that some people have already reported, but
> currently no clue who actually turns down the pin to D3.
> Conexant guys wrote me that the codec doesn't do it by itself, and the
> driver neither, AFAIK.  A possible answer is the firmware / BIOS, but
> who knows.

Thanks for the answer! :)=20

> In anyway, could you try to trace the hd-audio events and see whether
> the power down is *not* issued by the driver when you see this state?
> See Documentation/sound/alsa/HD-Audio.txt, the section "Tracepoints"
> for a brief instruction.

I can give it a try...=20

kevin

--Sig_/lVz734TR50=k5IpX25wU2gy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7gQPAAoJEEs3sNgP+7teiKQQAMWdJjzfYV3Jj0HvPYJufzN6
9pBeDqdR8SwK5Q0DP39eq0tuygC6GeWJx+jMl3REcjX6/SmUr0Qm662WAsjXnrTh
L6GhibS/Dtn2cU2LBDp+5w6jRivabvjHJSM9HY2AvT6ah4C1tEJ6PQcZRVVDsHZ2
M5PKvoHElJI7GcFWm+7MXIziIbByc/Oi6CQCMT/EGhQhFTbNV7hT9X5AHV1gLOVf
w2nvQbWlDAVgAotAs7FTIWycz+eZ+hgiTXVXiYiuWsqixS8TKxujtjzEaPxaXzRL
wbRoOr4/7igLCydDplOOVm+LCbri7M9Cr1IBHBdmYtprQGdMkgUFCcQvGBhZSHh9
jGFVJyRJDMhFmItcLxGBSzHGn6ztgRcVBttl62PMfcbcdO9seATz99cOLRv9mnyv
QY4+1kAPfaWC9i6qwe9OhTOZiLtr1toenHN4YEYH/M+FzgPlgFOy0b5bKjvLr1mQ
NsZY2QKY4RpFGWgADdQVhEP4+4ovDKYesopX3zTz7YCdA0dBjJwYZ8e1dGkagcZi
XabQ/Rleoz/6nlqMkv3HYex9v0/9k/17XYHexHDBWQB3p2azjzFoU0/MHoUk2qNE
Ov8t7mB+YKREmRrLwl2goMKvDw7SaewcTHeNgDyx/fnlJ2Ws8kdqJhbq+ex+tlaz
MZf/3513q+E3Z7qzPQ8c
=jFg/
-----END PGP SIGNATURE-----

--Sig_/lVz734TR50=k5IpX25wU2gy--
