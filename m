Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0LOUlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:41:53 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:37378 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab0LOUlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:41:49 -0500
Date: Wed, 15 Dec 2010 13:41:48 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] UAS updates
Message-ID: <20101215204147.GA1263@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Greg,

The following changes since commit 0fcdcfbbc98f70f559e4b36773a69972489a6d8f:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq (2010-12-14 18:50:10 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/willy/uas.git master

Matthew Wilcox (5):
      uas: Fix up the Sense IU
      uas: Use kzalloc instead of kmalloc
      uas: Rename sense pipe and sense urb to status pipe and status urb
      uas: Ensure we only bind to a UAS interface
      uas: Use GFP_NOIO instead of GFP_KERNEL in I/O submission path

 drivers/usb/storage/uas.c |   82 +++++++++++++++++++++++++++++---------------
 1 files changed, 54 insertions(+), 28 deletions(-)

I'll send the patches as replies to this mail.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
