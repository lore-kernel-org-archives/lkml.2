Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab2GSUQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 16:16:00 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61534 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2GSUP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 16:15:58 -0400
Date: Thu, 19 Jul 2012 13:15:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.38
Message-ID: <20120719201553.GA2089@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.38 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                |    2=20
 arch/arm/plat-samsung/adc.c             |    8 +-
 drivers/hwmon/it87.c                    |    2=20
 drivers/input/joystick/xpad.c           |    1=20
 drivers/media/dvb/dvb-core/dvbdev.c     |    1=20
 drivers/mtd/nand/nandsim.c              |   12 ---
 drivers/net/e1000e/82571.c              |    3=20
 drivers/net/wireless/rt2x00/rt2x00usb.c |    2=20
 drivers/platform/x86/intel_ips.c        |   22 +++++
 fs/buffer.c                             |   22 +++--
 fs/fifo.c                               |    9 +-
 include/linux/hrtimer.h                 |   10 ++
 include/linux/timex.h                   |    2=20
 kernel/hrtimer.c                        |   53 +++++++++----
 kernel/time/ntp.c                       |  124 ++++++++++-----------------=
-----
 kernel/time/timekeeping.c               |  115 ++++++++++++++++++++++-----=
--
 net/ipv4/tcp_input.c                    |    2=20
 net/wireless/util.c                     |    2=20
 18 files changed, 233 insertions(+), 159 deletions(-)

Anders Kaseorg (1):
      fifo: Do not restart open() if it already found a partner

Eric Dumazet (1):
      tcp: drop SYN+FIN messages

Greg Kroah-Hartman (1):
      Linux 3.0.38

Herton Ronaldo Krzesinski (1):
      mtd: nandsim: don't open code a do_div helper

Jean Delvare (1):
      hwmon: (it87) Preserve configuration register bits on init

Jeff Moyer (1):
      block: fix infinite loop in __getblk_slow

John Stultz (5):
      ntp: Fix leap-second hrtimer livelock
      timekeeping: Fix CLOCK_MONOTONIC inconsistency during leapsecond
      hrtimer: Provide clock_was_set_delayed()
      timekeeping: Fix leapsecond triggered load spike issue
      hrtimer: Update hrtimer base offsets each hrtimer_interrupt

Michal Kazior (1):
      cfg80211: check iface combinations only when iface is running

Richard Cochran (1):
      ntp: Correct TAI offset during leap second

Santosh Nayak (1):
      media: dvb-core: Release semaphore on error path dvb_register_device()

Stanislaw Gruszka (1):
      rt2x00usb: fix indexes ordering on RX queue kick

Takashi Iwai (1):
      intel_ips: blacklist HP ProBook laptops

Thomas Gleixner (5):
      time: Move common updates to a function
      timekeeping: Maintain ktime_t based offsets for hrtimers
      hrtimers: Move lock held region in hrtimer_interrupt()
      timekeeping: Provide hrtimer update function
      timekeeping: Add missing update call in timekeeping_resume()

Todd Poynor (1):
      ARM: SAMSUNG: fix race in s3c_adc_start for ADC

Tushar Dave (1):
      e1000e: Correct link check logic for 82571 serdes

Yuri Khan (1):
      Input: xpad - add Andamiro Pump It Up pad


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJQCGr5AAoJEDjbvchgkmk+BsQQAMuWbR/1W4guukAOJclCBM2I
Mw9uc+q8D6YWicNcJVj27jZOGGVIe+yajSdTT2ijUveFzeV7ihl3HzEvnLgmH4XN
E7n9KBZdkh7FNiML4+85SBRielgGyZ2yw+rl0G7xGQx2vfU5elQUuCju10jX5m7D
sWf+2TDQdxcaWL+S4nw3CX/X54gdpXbLdcA5j3hI96MHBDRuyKmyYirxn8VJZtTj
g3vQ2eufpvWq4hEz99oyldQvOwuDTtIfYd495+TMOzZYICXbxwJdkAwIMRNRl1HO
C3o8kXFHSWxGXHU1J4aHvlPrQ5IzpTKJu2CiPu8QeUavGohGQvk2gB8ytZCJAu3H
4EQdczJCjrMgGvTa47pmvVZFK4vH9JMsrQQBX86nQdMAKNCX2CnKEEnsOszb0yvc
4eOgYTyV4pDBeF1bXV6dYUmP3BAjbsPam6YweYWyQC1tvwK9uCmlyzweTnT2yu5H
U72ZGIeNPdIbxEvDWbkE9aa0N1UnYDxbZHZics2/vyUaIDxXJwPAbrrJdoRgvqiw
octI0LXkyS5K8Qs+uuMICEvfWN00rIb872DBgijFzAa9xmBIXdQq1Qc4x40nAEv/
I918dv5nKhgfsoqo5qBt++3IKhH+y9lopzqwhiJIs4Xk8ooUDt1NAO8gEJQoRwNm
TIP+zGMQBIqeWcVqcA2G
=Qoow
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
