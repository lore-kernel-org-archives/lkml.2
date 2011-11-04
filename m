Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab1KDODI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 10:03:08 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:36343 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932455Ab1KDODH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 10:03:07 -0400
Message-ID: <4EB3F094.30307@lougher.demon.co.uk>
Date: Fri, 04 Nov 2011 14:03:00 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Squashfs updates for 3.2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling the following minor Squashfs update.

Thanks

Phillip


The following changes since commit c3b92c8787367a8bb53d57d9789b558f1295cc96:

   Linux 3.1 (2011-10-24 09:10:05 +0200)

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-next.git master

Phillip Lougher (1):
       Squashfs: Add an option to set dev block size to 4K

  fs/squashfs/Kconfig       |   22 ++++++++++++++++++++++
  fs/squashfs/squashfs_fs.h |    7 +++++++
  fs/squashfs/super.c       |    2 +-
  3 files changed, 30 insertions(+), 1 deletions(-)
