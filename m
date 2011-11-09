Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434Ab1KIAJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:09:57 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58615 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932999Ab1KIAJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:09:56 -0500
X-Sasl-enc: InSTZ6HBv5hEYT24+BzPFn3FF4Bmx3hk/QJAIbqfa7gc 1320797395
Date: Tue, 8 Nov 2011 16:09:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.48
Message-ID: <20111109000925.GA26052@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 2.6.32.48 kernel.

It fixes a number of reported build errors with the 2.6.32.47 kernel.
If you aren't hitting them, then there's no need for you to upgrade at
this point in time.

The updated 2.6.32.y git tree can be found at (NOTE THE ADDRESS CHANGE):
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=shortlog;h=refs/heads/linux-2.6.32.y

thanks,

greg k-h

------------

 Makefile                   |    2 +-
 arch/powerpc/sysdev/mpic.c |   17 ++++++++++++-----
 drivers/base/sys.c         |    6 ------
 drivers/xen/events.c       |    2 +-
 include/linux/interrupt.h  |    5 -----
 kernel/irq/pm.c            |   35 +++++++----------------------------
 sound/soc/codecs/wm8940.c  |    2 --
 7 files changed, 21 insertions(+), 48 deletions(-)

Greg Kroah-Hartman (4):
      Revert "genirq: Add IRQF_RESUME_EARLY and resume such IRQs earlier"
      Revert "ASoC: wm8940: Properly set codec->dapm.bias_level"
      Revert "powerpc/mpic: Fix problem that affinity is not updated"
      Linux 2.6.32.48


--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOucS1AAoJEDjbvchgkmk+FMAP/i6vtlRrVM2pRM88DmjlZKw4
oCWtcQMCH7rGvny5Y9QEdtFS4SBDTDcH+Qe9LkDarcBb3Sf9U1/l0mpJ2OSjcTU5
Eaw+jCS19BUZSzv8rXIoMM+pOvbiFv8EVKJoEW9fS+FnKmQ/tBbq2NeDQIM9/N9U
JYD9lKQtCYalSS1fbk/2NdXJwC03H0fmUebPqzgaCw67oFcOT3tuVdewBOwzhpZA
PFLXBTQmS+1zWKZuxLr3+ugZNzeqUjFMmwFTUJDfNa1gVGr5Yu7q2Wza1+/73RqP
3Khs2TaTLcDf683HdyAKJWmzgaz9xGpZhw/ZEl7XgR+YKkTzJpydpGx6bWHjUpy0
ncRnW0vE8NEMi9kqxXDjfUB0ilfEhAxlRR65qkQOvN1FlNvkXBz2TKFG1KJnKo6M
GcDMvZO5mUd5wFDL8b6WNC5canBGhx/23/IJE6rzCH4vUq3dcIHwgPAdvNzU3Lgp
5aW3iF3NZ1sLNSi9wdB9PtJ4ItJZICtDs46kBJY7HhzN8MJmG+/XXNvRECGovaJq
JSOOyLPisGk4dv/aUXJm2X/fWs6ie0yPyRaI9IDJskTgxN/5nKF/ZmGTyUq9K+gd
6ugsNv3mmTH4srodX0Yh9gSDM/Io6Otuvx8FjlHC7N31X0crNSjMQynyVzjjuS+B
QZqc4aOLWBzTqqn5hnRw
=uHj8
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
