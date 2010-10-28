Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0J1Lni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:43:38 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:49958 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754304Ab0J1Lne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:43:34 -0400
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] fs: peel back the inode_lock some more
Date: Thu, 28 Oct 2010 22:42:38 +1100
Message-Id: <1288266161-28897-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

These as the first versions of the patches that remove the inode
lock from the writeback lists, superblock inode lists and the inode
hash table. I haven't polished them at all, but they appear to work
ok so I thought I'd send them out for comments before I went to bed...

With these patches the inode_lock pretty much disappears from my
lock_stat profiles, with the writeback list lock being the most
contended of the replacements on an 8-way machine.

Cheers,

Dave.
