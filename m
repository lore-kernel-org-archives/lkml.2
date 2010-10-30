Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0J3X60 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 19:58:26 -0400
Received: from mail.perches.com ([173.55.12.10]:3858 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab0J3X6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 19:58:24 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 0/2] kernel/module.c: A little neatening
Date: Sat, 30 Oct 2010 16:58:20 -0700
Message-Id: <cover.1288482645.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (2):
  kernel/module.c: Use pr_<level> and pr_fmt
  kernel/module.c: Use pr_debug and other neatening

 kernel/module.c |  305 ++++++++++++++++++++++++++-----------------------------
 1 files changed, 146 insertions(+), 159 deletions(-)

-- 
1.7.3.1.g432b3.dirty

