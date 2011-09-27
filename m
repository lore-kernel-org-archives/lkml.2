Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab1I0VlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 17:41:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42576 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab1I0VlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 17:41:18 -0400
From: jim.cromie@gmail.com
To: joe@perches.com
Cc: jbaron@redhat.com, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: [revised patches 25,26/26] dynamic_debug: add pr_fmt_*()
Date: Tue, 27 Sep 2011 15:40:58 -0600
Message-Id: <1317159660-2506-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316725066.29447.16.camel@Joe-Laptop>
References: <1316725066.29447.16.camel@Joe-Laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Joe,

Heres those pr_fmt_*() defns, added to printk.
While not essential, they do have a certain symmetry.

The biggest issue (still small) is that pr_fmt_debug() no longer has
different defns for DYNAMIC_DEBUG=y/n builds, so either y-builds get
KBUILD_MODNAME or n-builds dont.  Users can add an #if-else to get
both defns, which is less action-at-a-distance, so seemed better
overall.  We can revisit this later.

[PATCH 25/26] dynamic_debug: add pr_fmt_debug() for dynamic_pr_debug
[PATCH 26/26] scx200_acb: use pr_(info|warn|err|debug) and
