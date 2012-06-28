Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab2F1TFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 15:05:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab2F1TFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 15:05:07 -0400
Date: Thu, 28 Jun 2012 15:04:52 -0400
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu
Cc: rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        a.p.zijlstra@chello.nl, hpa@zytor.com, linux-kernel@vger.kernel.org
Message-Id: <cover.1340909155.git.jbaron@redhat.com>
Subject: [PATCH 0/2] deprecate static_branch()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Enough time has passed since the static_branch() -> static_key_false()
transition. Remove the last user of static_branch(), and kill off
static_branch().

Thanks,

-Jason


Jason Baron (2):
  tracepoint: use static_key_false(), since static_branch() is
    deprecated
  jump label: remove static_branch()

 include/linux/jump_label.h |   17 +----------------
 include/linux/tracepoint.h |    2 +-
 2 files changed, 2 insertions(+), 17 deletions(-)

