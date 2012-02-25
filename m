Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab2BYPyN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 10:54:13 -0500
Received: from imr4.ericy.com ([198.24.6.9]:44494 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050Ab2BYPyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 10:54:12 -0500
Date: Sat, 25 Feb 2012 07:52:02 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.3-rc5
Message-ID: <20120225155202.GA21187@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.3-rc5 from tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter

------

The following changes since commit b01543dfe67bb1d191998e90d20534dc354de059:

  Linux 3.3-rc4 (2012-02-18 15:53:33 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Chris D Schimp (2):
      hwmon: (max6639) Fix FAN_FROM_REG calculation
      hwmon: (max6639) Fix PPR register initialization to set both channels

Guenter Roeck (2):
      hwmon: (ads1015) Fix file leak in probe function
      hwmon: (max34440) Fix resetting temperature history

Nikolaus Schulz (1):
      hwmon: (f75375s) Fix register write order when setting fans to full speed

 drivers/hwmon/ads1015.c        |    3 +--
 drivers/hwmon/f75375s.c        |    7 +++----
 drivers/hwmon/max6639.c        |   22 ++++++++++++----------
 drivers/hwmon/pmbus/max34440.c |    2 +-
 4 files changed, 17 insertions(+), 17 deletions(-)

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPSQOhAAoJEMsfJm/On5mBIoMQAK2gNQGx1SpzhAyKM9wL9LNo
BYZhMOfC63GPd/V/KkQd31C+Z5NgE9z/6R9aBN0u8xg2ZSZJY6/ccRNyLjc7yqxc
OSE4CUzP5iQO36bUl6tX1B2TgfYBwbvVNUsShjsq/hoAzICIyk4UAVgmnRNN4iX5
JNLjxwhX7jXSJem8bvGVLkGkfIS6g/dYd1vqFvSZ0NlKxuB+5s0JVkB+xagBsl/+
YOMk4fqn0nIbPTffXs21khzvtZJTIr0LpVy3xb9BIx9Qwjc+KFBfLQEwwT/wniP8
RmO+5vq6n7pmm7lkbe2Wn9ta4JPSbXF5xe376GXjc6rUEcjllmIZghlKb6KSjZdC
Pd7CaWxAK5rrDCbrx7PqIvtXNWQ9xA9JyGqdlGTbGW/GW/Fd2W7srj2sUh9Rl1AV
fbXb7Iea6JgUnTRqAD1fao5FvYZLu//XHimo8xE6V4EyzR56OOc/JP50EaLQnh2s
AEoe4fWIjsp5zLzE+jQwSuEJgwDikfweV8InX57hnCJi7y3QU3jWCoZfEXumqY64
HIwQW13q2Rlb65eUlr4GnHrLTh307tyXypWm9cS4XCCOXvuHPhxiobkNLNHo44r5
XaWv87tu6nx8PE4I1INw9S/uj5PcRdzDS/DUX5GRMxv4fFfV17u3dyEm1zm7E59m
SE+vhU2BTYyoICggUl1E
=1ocM
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
