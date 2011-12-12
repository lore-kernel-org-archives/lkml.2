Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1LLHOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:14:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59153 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab1LLHN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:13:56 -0500
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 00/11] kvm tools: cleanups
Date: Mon, 12 Dec 2011 15:15:44 +0800
Message-Id: <1323674155-17570-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-12 15:13:20,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-12 15:13:21,
	Serialize complete at 2011-12-12 15:13:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are small patches and almost are cleanups.
patch 1 and patch 10 may be 2 fixies if I'm not mental disorder.

Lai Jiangshan (11):
  check condition before wait
  fix function name
  move threadpool.c to util/
  move rbtree.o to util/
  add missing build output
  move read-write.c to util/
  move util.c to util/
  move strlcat() to util/strbuf.c
  narrow the C.S. of compat_mtx
  protect shared global id in compat_mtx C.S.
  remove duplicated code

 tools/kvm/Makefile                |   11 +++++----
 tools/kvm/builtin-run.c           |    1 +
 tools/kvm/guest_compat.c          |   39 ++++++++++++++++--------------------
 tools/kvm/include/kvm/strbuf.h    |   13 ++++++++++++
 tools/kvm/include/kvm/util.h      |   10 ---------
 tools/kvm/{ => util}/read-write.c |    0
 tools/kvm/util/strbuf.c           |   26 ++++++++++++++++++++++++
 tools/kvm/{ => util}/threadpool.c |   25 +++++++++++------------
 tools/kvm/{ => util}/util.c       |   25 -----------------------
 9 files changed, 75 insertions(+), 75 deletions(-)
 rename tools/kvm/{ => util}/read-write.c (100%)
 rename tools/kvm/{ => util}/threadpool.c (89%)
 rename tools/kvm/{ => util}/util.c (71%)

-- 
1.7.4.4

