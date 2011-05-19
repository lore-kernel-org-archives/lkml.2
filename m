Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab1ESJJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:09:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab1ESJJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:09:47 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Thu, 19 May 2011 09:46:55 +0100
Message-Id: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This time, most of the GFS2 patches are code clean up, although there
are a few bug fixes (fallocate/ail writeback/end of life inodes/nlink) and
some new features (new tracepoint & tracing flags, using the UUID field
in the generic superblock).

The changes can be broadly divided into three sets:

1. Bob's directory code clean up
2. My fsync/ail writeback fixes & clean up
3. inode.c/ops_inode.c clean up

Steve.

