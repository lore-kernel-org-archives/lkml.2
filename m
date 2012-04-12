Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660Ab2DLMVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 08:21:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933299Ab2DLMVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 08:21:22 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] perf, tool: kvm record & event processing fixies
Date: Thu, 12 Apr 2012 14:20:59 +0200
Message-Id: <1334233262-5679-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending fix for 'perf kvm record' to force guest kernel
machine specification option (patch 1). I'm not completely
sure there might be better solution for this like some
dummy guest machine record.

And 2 other bug fixies I cross when hunting the first
one (patch 2,3).

Attached patches:
 1/3 perf, tool: Force guest machine definition option
 2/3 perf, tool: Skip event correctly for unknown id/machine
 3/3 perf, tool: Fail on processing event with unknow size

thanks,
jirka
---
 tools/perf/builtin-kvm.c  |   10 ++++++++++
 tools/perf/util/session.c |   32 +++++++++-----------------------
 2 files changed, 19 insertions(+), 23 deletions(-)
