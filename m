Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab2BCOWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:22:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583Ab2BCOWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:22:50 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: [PATCHv8 0/2] first 2 patches passed review
Date: Fri,  3 Feb 2012 15:22:37 +0100
Message-Id: <1328278959-5775-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1328278128.5882.145.camel@gandalf.stny.rr.com>
References: <1328278128.5882.145.camel@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok, sending 1st 2 patches separatelly

thanks,
jirka
---
 include/linux/ftrace.h |   70 ++++++++++++++++++++++++++-
 kernel/trace/ftrace.c  |  126 +++++++++++++++++++++++++++++++++++++++++++-----
 kernel/trace/trace.h   |    2 +
 3 files changed, 183 insertions(+), 15 deletions(-)
