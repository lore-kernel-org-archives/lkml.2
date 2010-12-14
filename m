Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677Ab0LNAos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:44:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59366 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab0LNAor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:44:47 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=l5swMuWkAmkA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=oAQ0cHfLaSDtiXPJpL4A:9 a=CTNtu80HZzCk8pT55UAA:7 a=wYM8wkzMsvnUfyCp2bron9KhkQAA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101214004347.996651495@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 19:43:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] mm: Remove unlikely likelys
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure who to send this to. I've separated out my patch set
per system, and I'm sending them out individually. You can simply
pull from my repo, or take the patches directly from me.

Or just ignore me and I'll come and bother you again next year ;-)

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: unlikely/mm


Steven Rostedt (3):
      mm: Remove likely() from mapping_unevictable()
      mm: Remove unlikely() from page_mapping()
      mm: Remove likely() from grab_cache_page_write_begin()

----
 include/linux/mm.h      |    2 +-
 include/linux/pagemap.h |    2 +-
 mm/filemap.c            |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)
