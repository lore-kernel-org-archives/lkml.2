Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2LEVsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:48:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab2LEVsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:48:30 -0500
Date: Wed, 5 Dec 2012 16:48:25 -0500
From: Jason Baron <jbaron@redhat.com>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com, jim.cromie@gmail.com, linux-kernel@vger.kernel.org
Message-Id: <cover.1354741891.git.jbaron@redhat.com>
Subject: [PATCH 0/3] dynamic_debug: Add print_hex_dump_bytes/debug support and cleanups 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here's a collection of the latest dyanmic debug patches that I have
pending. 

Thanks,

-Jason

Jim Cromie (1):
  dynamic_debug: add pr_errs before -EINVALs

Joe Perches (1):
  dynamic_debug: Fix vpr_<foo> logging styles

Vladimir Kondratiev (1):
  dynamic_debug: dynamic hex dump

 Documentation/dynamic-debug-howto.txt |   15 +++-
 include/linux/dynamic_debug.h         |   11 ++
 include/linux/printk.h                |   17 ++++
 lib/dynamic_debug.c                   |  165 +++++++++++++++++++--------------
 lib/hexdump.c                         |    4 +-
 5 files changed, 141 insertions(+), 71 deletions(-)

