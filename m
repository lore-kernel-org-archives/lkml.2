Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab1CPRL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:11:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab1CPRLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:11:21 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] dlm patches for 2.6.39
Date: Wed, 16 Mar 2011 11:42:00 -0500
Message-Id: <1300293723-29693-1-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These are the dlm patches from -next for the 2.6.39 merge.

David Teigland (3):
      dlm: record full callback state
      dlm: increase default hash table sizes
      dlm: use alloc_workqueue function

 fs/dlm/ast.c          |  257 +++++++++++++++++++++++++++++++++++++-----------
 fs/dlm/ast.h          |    7 +-
 fs/dlm/config.c       |    4 +-
 fs/dlm/debug_fs.c     |    4 +-
 fs/dlm/dlm_internal.h |   35 ++++---
 fs/dlm/lock.c         |   38 ++++----
 fs/dlm/lowcomms.c     |    6 +-
 fs/dlm/rcom.c         |    4 +-
 fs/dlm/user.c         |  185 ++++++++++++-----------------------
 fs/dlm/user.h         |    3 +-
 10 files changed, 317 insertions(+), 226 deletions(-)
