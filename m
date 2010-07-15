Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935030Ab0GOXgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 19:36:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32866 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933661Ab0GOXgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 19:36:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=V+I3yv3eUb6ibBk7qts+m3LUVpRsziqGi2oAeARA9dejw02/3WtVOoEmcYteJBJbQ/
         DKUgIwVzHv7RM4BDrWvhfW/W3aMyZXl4m4dRCf+j2Wn0ygWtiwTOokFN8yveFdUVArDR
         Cv+0VI21Dt5G30LuXa95YuGbtUGSaRWPxbYsU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Soeren Sandmann <sandmann@daimi.au.dk>, Ingo Molnar <mingo@elte.hu>
Subject: [RFC PATCH 0/2] tracing: Remove sysprof
Date: Fri, 16 Jul 2010 01:36:41 +0200
Message-Id: <1279237003-31354-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soeren,

Can I get your ACK on the first patch, so that I can propose it
for the -tip tree?

Thanks.

Frederic Weisbecker (2):
  tracing: Remove sysprof ftrace plugin
  tracing: Remove special traces

 include/linux/kernel.h        |    5 -
 include/linux/sched.h         |   12 --
 kernel/trace/Kconfig          |    9 -
 kernel/trace/Makefile         |    1 -
 kernel/trace/trace.c          |   58 -------
 kernel/trace/trace.h          |    9 -
 kernel/trace/trace_entries.h  |   17 --
 kernel/trace/trace_output.c   |   66 --------
 kernel/trace/trace_selftest.c |   33 ----
 kernel/trace/trace_sysprof.c  |  330 -----------------------------------------
 10 files changed, 0 insertions(+), 540 deletions(-)
 delete mode 100644 kernel/trace/trace_sysprof.c

