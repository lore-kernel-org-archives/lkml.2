Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab1GVJjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 05:39:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab1GVJjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:39:39 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Fri, 22 Jul 2011 10:16:50 +0100
Message-Id: <1311326214-3325-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Not a lot new this time... the addition of a cache for the directory hash table
improve directory read/lookup speed, automatic adjustment of the glock hold
time improves performance for some contention corner cases. S_NOSEC support
is another performance related change, plus a nice clean up from Eric
Sandeen,

Steve.

