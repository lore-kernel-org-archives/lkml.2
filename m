Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab2CSKtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:49:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab2CSKtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:49:41 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Mon, 19 Mar 2012 10:25:16 +0000
Message-Id: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Not a huge number of patches this time. Some notable new features
though:
 - Glock stats gathering (v. useful for performance analysis)
 - FITRIM ioctl support
 - Sorting the ordered write list (big performance increase when the workload
   doesn't result in the write requests being nicely ordered to start with)

Plus a few clean ups, and bug fixes in addition,

Steve.


