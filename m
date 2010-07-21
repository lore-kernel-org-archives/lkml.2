Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab0GUU0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 16:26:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab0GUU0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 16:26:39 -0400
In-Reply-To: <4C46FD67.8070808@redhat.com>
References: <4C46D1C5.90200@gmail.com> <4C46FD67.8070808@redhat.com>
From: Andreas Gruenbacher <agruen@suse.de>
Date: Wed, 21 Jul 2010 19:57:20 +0200
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Eric Sandeen <sandeen@redhat.com>, hch@infradead.org,
        "linux-ext4" <linux-ext4@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org,
        "kernel-janitors" <kernel-janitors@vger.kernel.org>,
        "Wang Sheng-Hui" <crosslonelyover@gmail.com>
Subject: [PATCH 0/2] mbcache fixes
Message-Id: <20100721202637.4CC213C539AA@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

here is an mbcache cleanup and then a fixed version of Shenghui's minor
shrinker function fix.  The patches have survived functional testing
here.

This seems slightly too much for kernel-janitors, so could you please
take the patches?

Thanks,
Andreas

Andreas Gruenbacher (2):
  mbcache: Remove unused features
  mbcache: fix shrinker function return value

 fs/ext2/xattr.c         |   12 ++--
 fs/ext3/xattr.c         |   12 ++--
 fs/ext4/xattr.c         |   12 ++--
 fs/mbcache.c            |  168 ++++++++++++++---------------------------------
 include/linux/mbcache.h |   20 ++----
 5 files changed, 70 insertions(+), 154 deletions(-)

-- 
1.7.2.rc3.57.g77b5b

