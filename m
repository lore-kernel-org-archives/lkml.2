Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935189Ab0KQRhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:37:16 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43759 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935147Ab0KQRhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:37:10 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaurora@redhat.com, neilb@suse.de, viro@zeniv.linux.org.uk,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 0/2] overlayfs fixes
Date: Wed, 17 Nov 2010 17:37:02 +0000
Message-Id: <1290015424-5583-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did some further testing of overlayfs using it to boot a live filesystem,
which was unsuccessful overall.  I found a couple of issues thrown up by
using squashfs as the underlying layer. Following this email are a couple
of fixes I used to get much closer.

Also, do you have a rebased version of this code for v2.6.37-rc2?
I had a quick run at it and ended up messing it up (panics on boot).

-apw

Andy Whitcroft (2):
  overlayfs: handle missing lower inodes in ovl_is_same_inode
  overlayfs: ovl_copy_up_xattr -- handle EOPNOTSUPP from vfs_listxattr

 fs/overlayfs/overlayfs.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

