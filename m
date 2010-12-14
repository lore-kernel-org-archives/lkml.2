Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433Ab0LNAkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:40:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41088 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721Ab0LNAkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:40:42 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=QOrHK6yRskcA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=1gxbl2yO0ND_J2xBWXIA:9 a=4kykOjFe-7VyXEV7pAAA:7 a=n0MdEMJtD_VkX7Ep_9nG5SYcY6oA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101214003807.693481687@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 19:38:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] fs: Removal of unlikely likelys
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure who to send this to. I've separated out my patch set
per system, and I'm sending them out individually. You can simply
pull from my repo, or take the patches directly from me.

Or just ignore me and I'll come and bother you again next year ;-)


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: unlikely/fs


Steven Rostedt (2):
      fs: Remove unlikely() from fput_light()
      fs: Remove unlikely() from fget_light()

----
 fs/file_table.c      |    2 +-
 include/linux/file.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
