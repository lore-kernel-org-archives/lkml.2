Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab2FFSoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:44:30 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56119 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab2FFSo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:44:29 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2012 14:44:29 EDT
X-Originating-IP: 108.223.40.66
Date: Wed, 6 Jun 2012 11:38:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.5-rc2
Message-ID: <20120606183802.GA5836@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.5-rc2 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

First time I am sending this from my home server. Hope it works.

Thanks,
Guenter
------

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

for you to fetch changes up to ca4620853a5b578725edec1fc8f1345db3a823ab:

  MAINTAINERS: Update my e-mail address (2012-06-03 08:13:41 -0700)

----------------------------------------------------------------
hwmon updates for 3.5-rc2

Update e-mail address in MAINTAINERS

----------------------------------------------------------------
Guenter Roeck (1):
      MAINTAINERS: Update my e-mail address

 MAINTAINERS |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPz6OJAAoJEMsfJm/On5mBpXIP/3NhZI0rL6Aagi6tJ2jdExSG
zZLjC1g3kg2/Gljei0BIFVNDk2te28v4TVV5qyetI0QZ1ZPOyMC9ELWgM5QYGSbt
SXwKUDCHIqbamT07KeSd8vLKBRQzK0tMTCLs5kU/EQz7Uh3OtA95mqMRw1ssSpsY
PeYE1zTNjyixL5a3c/17FnloDnlIkhd3B/VvkNrubYKyVnpZQvcUznqz/Ugp8Ezo
qessUwxW8AEwm2LG6WY/MO02Pvpt2IvYj5hRV6C4EwNqTcrBOiStvST6jvyctpA/
Km+xQtRUp7/ejGwT/bKkC2hCDk1aweUiSNWPdtKOHqdWTboWQAXdAgbFu6dyBAyz
MynVto/56iuTxpPsYTYDOJbmYTBUfkUXxeRda9YlCq3Q+caODtrzTqzItqqe/hf8
hVxehGnejHkYByQYzS0+VfthjxInI76fI7xU94XEv5iZLtYovOVgTTxhAeQdYMyM
/oG7tcdKXWEFK/SGfpBsqFvSAbvme5kTD4qps+YysykKuK/fVbdUR5I9R27h8YBX
eymes567LhtYTAHtc0/+e0osjKGlrxAZNtX1BG0LPEBa610Yr1e+++O3IfNdS1Vf
JHNpso/yXtG/nQgybVuTzx7BQogAxtaQdws0nuGcS+G7GkeF8NAp2X6+LDDpZUuj
KuxhjPtA8jPKWl9jCjCS
=G+Jj
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
