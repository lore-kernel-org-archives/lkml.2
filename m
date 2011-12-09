Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab1LIOie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:38:34 -0500
Received: from 8bytes.org ([88.198.83.132]:41531 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1LIOid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:38:33 -0500
Date: Fri, 9 Dec 2011 15:38:30 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU fixes for 3.2
Message-ID: <20111209143828.GA3398@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 5611cc4572e889b62a7b4c72a413536bf6a9c416:

  Linux 3.2-rc4 (2011-12-01 14:56:01 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git iommu/fixes

The top-commit on my development machine in the iommu/fixes branch is:

	b2c1639135c0fc1560f3fe9a3a83f2c8265a9e02

Joe Perches (1):
      MAINTAINERS: Update amd-iommu F: patterns

Joerg Roedel (1):
      iommu/msm: Fix compile error in mach-msm/devices-iommu.c

Sedat Dilek (1):
      iommu/amd: Fix typo in kernel-parameters.txt

Thomas Jarosch (1):
      Fix comparison using wrong pointer variable in dma debug code

 Documentation/kernel-parameters.txt |    2 +-
 MAINTAINERS                         |    4 ++--
 arch/arm/mach-msm/devices-iommu.c   |    1 +
 lib/dma-debug.c                     |    2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

Besides the documentation and MAINTAINERS fixes these patches fix a
wrong comparision in the dma-debug code introduced in the last merge
window and a compile error for the MSM-ARM platform when IOMMU is
enabled. Please pull.

Thanks,

	Joerg


--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO4h1kAAoJECvwRC2XARrjikcP/3vs60YyLpZarE6XCk29nbHA
j5LGsk3Yp7jF5sOUUa9yn/EA85ZWEEPTiOB+qJYS/ajQJ6ozWT3MMYR+ozt7W5R3
/gxSBpEuZnTEY7gPs5TbA6X1UNmG90UbkgO/32Q0CWce6fTUrOz/CgyIxEUmsstN
RvNZu5cPc1TOzO5VNUTQvWvO7RzT7B8ji5Jc3gTEw6vQ8uZCM8hsAGuHBhvH+aJ+
yh1MVpPxXjJPzfSI0XlF543vQybwmX6aB6tX7LpQnnP5w9YssKMT4nVnlzwaoV5D
G77TbtiV6x75YL6NKbjIHDLuzgwAygWR3aMqvGo7+acc5oJ4Sa5gqvpJRTZBAbFo
j2QLjgBthFgR78cfie6QgPXoYnaj8ZZcm5N9yT3QoGuZ2Un8U+8Uj8LPUsuos1+K
AFaHum4UyXpoXWWhh9pJ/AsI6XFis0nCOf0LoxlLQZP5cbmZGz65YVyYOo+7n+7r
K597nSvNHXKpQDrLMZs9sD98onl/VJ2h2fvjlWkfnUmoLaVkSv96O1yFcWBiFrC7
eQd2y9C5zYXGIgudJJ26ieR8N5TivG5UfHo1Nlb8hviCwlGX9ldIs2gIKndJOFx/
OvlcVKebn7QEWFMG6RboUY7OFm/ixfJeigSngIG8jZmwWpzIEmlEL1ymBmIomYZ2
xEsU7eWP3lB/SAo8QsQL
=BqNU
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
