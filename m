Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab2IMKIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:08:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab2IMKIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:08:04 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (fixes)
Date: Thu, 13 Sep 2012 10:42:26 +0100
Message-Id: <1347529349-6704-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are three GFS2 fixes for the current kernel tree. These are all
related to the block reservation code which was added at the merge
window. That code will be getting an update at the forthcoming merge
window too. In the mean time though there are a few smaller issues
which should be fixed.

The first patch resolves an issue with write sizes of greater than
32 bits with the size hinting code. The second ensures that the
allocation data structure is initialised when using xattrs and the
third takes into account allocations which may have been made by
other nodes which affect a reservation on the local node,

Steve.

