Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab0DWCN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 22:13:56 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:44392 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754475Ab0DWCNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 22:13:55 -0400
Message-ID: <4BD10226.6050105@lougher.demon.co.uk>
Date: Fri, 23 Apr 2010 03:12:54 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/4] Squashfs: bug fixes for 2.6.34-rc6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are some important bug fixes for 2.6.34-rc6.

Phillip Lougher (4):
       squashfs: fix locking bug in zlib wrapper
       squashfs: fix warn_on when root inode is corrupted
       squashfs: add missing buffer free
       squashfs: fix potential buffer over-run on 4K block file systems

  fs/squashfs/block.c        |    5 ++---
  fs/squashfs/super.c        |    4 +++-
  fs/squashfs/zlib_wrapper.c |    3 ++-
  3 files changed, 7 insertions(+), 5 deletions(-)

Thanks

Phillip
