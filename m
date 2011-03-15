Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab1COJdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:33:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765Ab1COJds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:33:48 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Tue, 15 Mar 2011 09:11:30 +0000
Message-Id: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The most interesting "feature" in this patch set is the RCU glock
patch which has been a long time coming, but is finally here. That
patch contains most of the changes this time. The other patches ins
this set are mostly smaller bug fixes and performance improvements.

Steve.


