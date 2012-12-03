Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab2LCOlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:41:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab2LCOll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:41:41 -0500
Message-ID: <50BCBA12.5030808@redhat.com>
Date: Mon, 03 Dec 2012 12:41:22 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux EDAC Mailing List <linux-edac@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>
Subject: [GIT PULL for 3.8-final] EDAC fixes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git master

For one EDAC core fix, and a few driver fixes (i7300, i9275x, i7core).

Thank you!
Mauro

The following changes since commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:

   Linux 3.6 (2012-09-30 16:47:46 -0700)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git master

for you to fetch changes up to 42709efb3a47524c6252e1bdc85e205f7bc356fb:

   i7core_edac: fix panic when accessing sysfs files (2012-11-28 06:56:00 -0200)

----------------------------------------------------------------
Jean Delvare (1):
       i7300_edac: Fix error flag testing

Mauro Carvalho Chehab (3):
       Merge tag 'v3.6' into fixes
       i82975x_edac: Fix dimm label initialization
       edac: Fix the dimm filling for csrows-based layouts

Prarit Bhargava (1):
       i7core_edac: fix panic when accessing sysfs files

  drivers/edac/edac_mc.c      | 14 +++++++++++---
  drivers/edac/i7300_edac.c   |  8 ++++----
  drivers/edac/i7core_edac.c  |  6 +++---
  drivers/edac/i82975x_edac.c | 11 ++++-------
  4 files changed, 22 insertions(+), 17 deletions(-)

