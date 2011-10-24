Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab1JXMrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:47:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab1JXMrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:19 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Mon, 24 Oct 2011 13:48:14 +0100
Message-Id: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since the merge window is upon us, here is the current content of
the GFS2 git tree. A few things will be help back to the following
merge window in order to ensure a greater test time, but those currently
in the tree are ready for the current window.

Recently I've reconstituted the GFS2 git tree, so it can be pulled
(via http) from:

http://sucs.org/~rohan/git/gfs2-3.0-nmw

and viewed via gitweb at:

http://sucs.org/gitweb/

This is thanks to the Swansea University Computer Society for providing
a temporary (or possibly permanent) home for the GFS2 git trees. Please
treat their server kindly as this will only continue while it doesn't
generate too much traffic. I figure that there will not be too many
people pulling the GFS2 tree at once, but we'll see.

Some highlights of the current patch set:
 o Reduction in code of approx 400 lines
 o Big clean up (and speed up) in the resource group code
   - This is a nice base to build some forthcoming improvements on
   - It should improve performance with multi-threaded workloads
 o Some left-over fsync/writeback changes
 o Improvements to readahead when deallocating large directories

Any questions/concerns then please let me know as usual,

Steve.


