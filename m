Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356Ab2BJOng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:43:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62508 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab2BJOnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:43:35 -0500
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 0/5] ptrace tweaks
Date: Fri, 10 Feb 2012 15:43:06 +0100
Message-Id: <1328884991-23889-1-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set fixes a minor bug in PTRACE_SETOPTIONS,
slightly extends PTRACE_SEIZE (now it can take ptrace options),
changes PTRACE_EVENT_STOP value,
and enables PTRACE_SEIZE for non-development use.

Ptrace git tree on kernel.org is not restored yet,
so this patch set can't go through it.

Andrew, please consider taking this patch set.

Denys Vlasenko (5):
  ptrace: don't modify flags on PTRACE_SETOPTIONS failure
  ptrace: simplify PTRACE_foo constants and PTRACE_SETOPTIONS code
  ptrace: make PTRACE_SEIZE set ptrace options specified in 'data' parameter
  ptrace: renumber PTRACE_EVENT_STOP so that future new options and
    events can match
  ptrace: remove PTRACE_SEIZE_DEVEL bit

 include/linux/ptrace.h |   39 ++++++++++++----------------
 kernel/ptrace.c        |   64 ++++++++++++++++++------------------------------
 2 files changed, 41 insertions(+), 62 deletions(-)

-- 
1.7.7.6

