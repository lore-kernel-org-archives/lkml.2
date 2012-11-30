Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab2K3KSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:18:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab2K3KSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:15 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Fri, 30 Nov 2012 09:52:05 +0000
Message-Id: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So yes, this is a bit early, but the tree seems to have settled down
now, and I'd like to hold off any further feature patches until the
subsequent merge window at this stage.

The main feature this time is the new Orlov allocator and the patches
leading up to it which allow us to allocate new inodes from their own
allocation context, rather than borrowing that of their parent directory.
It is this change which then allows us to choose a different location
for subdirectories when required. This works exactly as per the ext3
implementation from the users point of view.

In addition to that, we've got a speed up in gfs2_rbm_from_block()
from Bob Peterson, three locking related improvements from Dave
Teigland plus a selection of smaller bug fixes and clean ups.

Steve.

