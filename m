Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab0J2OAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:00:39 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:62657 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932586Ab0J2OAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:00:38 -0400
Message-ID: <4CCAD245.2010402@lougher.demon.co.uk>
Date: Fri, 29 Oct 2010 14:55:17 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Squashfs updates for 2.6.37
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling the following Squashfs updates which
fix some sparse warnings.

Thanks

Phillip

---------------
The following changes since commit f6f94e2ab1b33f0082ac22d71f66385a60d8157f:
   Linus Torvalds (1):
         Linux 2.6.36

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git master

Phillip Lougher (2):
       Squashfs: fix use of __le64 annotated variable
       Squashfs: fix function prototype

  fs/squashfs/xattr.c    |    9 +++++----
  fs/squashfs/xattr.h    |    4 ++--
  fs/squashfs/xattr_id.c |    1 +
  3 files changed, 8 insertions(+), 6 deletions(-)
