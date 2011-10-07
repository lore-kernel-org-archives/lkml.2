Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab1JGUeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:34:05 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37085 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab1JGUeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:34:02 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/26] dynamic_debug: add pending queries, etc (~resend)
Date: Fri,  7 Oct 2011 14:33:06 -0600
Message-Id: <1318019612-20068-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is essentially a rebase, resend, with trivial changes:
- drops scx200 - off topic
- adds pr_cont_once tweak - remove pr_fmt
as before, it has:
- Doc tweaks per Randy Dunlap
- pr_fmt_$severity, suggested by Joe Perches
- does not change pr_fmt() default, per Joe

Rebased onto git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
+ Jason's 8-12/12 which havent made it into driver-core
Ive not resent them here.

[jimc@groucho linux-2.6]$ git diff --stat jb-on-driver-core 
 Documentation/dynamic-debug-howto.txt |  334 +++++++++++------
 include/linux/device.h                |    8 +-
 include/linux/dynamic_debug.h         |   23 +-
 include/linux/netdevice.h             |    8 +-
 include/linux/printk.h                |   95 +++--
 lib/dynamic_debug.c                   |  685 +++++++++++++++++++++++++++------
 6 files changed, 866 insertions(+), 287 deletions(-)

