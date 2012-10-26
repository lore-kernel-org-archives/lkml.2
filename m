Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933962Ab2JZPnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:43:52 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54581 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933879Ab2JZPnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:43:50 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: hch@infradead.org, eparis@redhat.com, linux-audit@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] audit: minor audit cleanups
Date: Fri, 26 Oct 2012 11:43:39 -0400
Message-Id: <1351266222-11107-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are some cleanups suggested by HCH when he was reviewing
my audit set that went into 3.7. They should introduce no behavioral
changes. They're just cleanups for clarity's sake.

I think the first patch in the series makes a lot of sense. The last two
patches don't seem to provide as much improvement in clarity to me. I'm
not opposed to including them if others think they do, so I'll post
them here so we can debate their merits.

These (or some subset of these) are probably appropriate for 3.8.

Jeff Layton (3):
  audit: eliminate optional dentry argument to audit_copy_inode
  audit: break the setup of the audit_name out of audit_inode and into
    separate function
  audit: break up __audit_inode into two functions

 fs/open.c             |  4 ++--
 fs/xattr.c            |  8 ++++----
 include/linux/audit.h | 11 +++++++++-
 ipc/mqueue.c          |  4 ++--
 kernel/auditsc.c      | 57 ++++++++++++++++++++++++++++++++++++---------------
 5 files changed, 59 insertions(+), 25 deletions(-)

-- 
1.7.11.7

