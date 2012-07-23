Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab2GWOj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 10:39:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53677 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612Ab2GWOj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 10:39:58 -0400
Date: Mon, 23 Jul 2012 15:39:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Help request - ASoC recursion issue
Message-ID: <20120723143955.GA8071@opensource.wolfsonmicro.com>
References: <500D5A1F.9000808@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <500D5A1F.9000808@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 23, 2012 at 03:05:19PM +0100, Lee Jones wrote:

> I was wondering if I may bother you for some help. I've been having
> serious issues with testing the new mop500 sound system you have in

You might want to CC some of the people who wrote that code...

> The problem seems to be that 'dapm_supply_check_power()' then calls
> back into 'dapm_widget_power_check()'. Then round and round we go!

Please describe what the problem you think you're seeing is, you've just
cut'n'pasted the code into your mail without describing any actual
problem in the system...

The tree walk is recursive so the fact that we call the same function
more than once isn't terribly surprising.

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQDWItAAoJEBus8iNuMP3dH+8P+wb8jxonN/7NxikoRjK7ltEN
G71lEjSVzTpv2KytIWyou8U3xmNi2ykcYuyDagzZJLGZaGXHc+C9dlSj5JH7VHl0
ocPnZTNNJD0YPAXsz9yuxpC0ubeepetz6Z9UwUPrOiY/0C1c4ntMOG7vqvjMSgX/
bP1xZQLtwEiOaTUj15hjv0lRePZ8o5JXeSIvTx+DzCTdSa6FE14mHysaYIyAhQdn
T1yP2i3hu/DYYvf8QfqA1TV9eQshS7UVKMRY2/UC/FRnmujZ4m2r0UaS4c/s4Vg+
/brFa+w6Oxu/AgIvTNFgLjEaHOslweCjG9P2ZvrOpVbpzcN9MkZFPM6X/Lk94hyT
Y11cqW40f52J1Wa135WhVEWyTLuHgtM0XqwbaastmwpIh9GijxXW7jMNSlQXTu1F
TMHEn7Y6I3CBahO2FzeF5J3w3lSY7v0fvUway+cU0QJJBbpy+AkNIBnVQEpLBiwX
cVmW2gS6aeplnlkkWdZpwe49VrUzpk4SiRlBWLg97D23bUeh6kv49LAlLfKnms3H
n0aMutQphHbvBKi6Fl3+5i72KNgj8gy+kFzaL/pulPJakwUmLdev0GaxGkrMk8aF
T/4llFIBQ32N5H9sY3pxTglHJZsXB6PDohJigU7gT+gsNahE8QPYLofflM3Ccmm5
6CHdchhaYhTdAG0L96Lt
=4Iga
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
