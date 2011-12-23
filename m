Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab1LWS1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 13:27:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab1LWS1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 13:27:06 -0500
Message-ID: <4EF4C7E7.9060409@redhat.com>
Date: Fri, 23 Dec 2011 16:26:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.2-rc] media fix
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For a last time fix for the omap3 driver.

Thanks and Happy Seasons!
Mauro


Latest commit at the branch: 
c070e38e4ee005f55895df177a9e14d90d6204b3 [media] omap3isp: Fix crash caused by subdevs now having a pointer to devnodes
The following changes since commit 4b5d8da88e3fab76700e89488a8c65c54facb9a3:

  Revert "[media] af9015: limit I2C access to keep FW happy" (2011-12-12 16:02:15 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to c070e38e4ee005f55895df177a9e14d90d6204b3:

  [media] omap3isp: Fix crash caused by subdevs now having a pointer to devnodes (2011-12-19 18:07:41 -0200)

----------------------------------------------------------------
Laurent Pinchart (1):
      [media] omap3isp: Fix crash caused by subdevs now having a pointer to devnodes

 drivers/media/video/omap3isp/ispccdc.c |    2 +-
 drivers/media/video/omap3isp/ispstat.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

