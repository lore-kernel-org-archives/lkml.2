Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab2EaUoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:44:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40321 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2EaUoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:44:06 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] msync improvements
Date: Thu, 31 May 2012 22:43:53 +0200
Message-Id: <1338497035-13014-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches are improvements on the implementation of the msync
system call.  To give some context, I found them while working on
the implementation of a persistent dirty bitmap.

Paolo Bonzini (2):
  msync: support syncing a small part of the file
  msync: start async writeout when MS_ASYNC

 include/linux/fs.h |    3 +-
 mm/fadvise.c       |    2 +-
 mm/filemap.c       |   11 +++++---
 mm/msync.c         |   63 +++++++++++++++++++++++++++++++++-------------------
 4 files changed, 50 insertions(+), 29 deletions(-)

