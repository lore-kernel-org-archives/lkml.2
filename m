Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab0JROh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:37:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab0JROhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:25 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting
Date: Mon, 18 Oct 2010 15:15:24 +0100
Message-Id: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I know the merge window isn't open yet, but at this stage I'm going to
hold off on any larger patches until the following merge window so this
patch set isn't likely to change much, hence kicking it out a bit early
for review.

There are a few interesting points to note in this patch set:
 o GFS2 is updated to use the new truncate sequence
 o Support for fallocate is added
 o Clean up of some unused/obsolete mount options

I'm currently working on a patch to allow the glock hash table
to use RCU. That is currently a work-in-progress and that will
hopefully be ready for the succeeding merge window.

Steve.

