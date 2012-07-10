Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab2GJVsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 17:48:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2GJVsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 17:48:20 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/4] perf kvm: more bug fixes and cleanups
Date: Tue, 10 Jul 2012 15:48:10 -0600
Message-Id: <1341956894-69284-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo:

Please consider applying the following patches while Arnaldo is on
vacaction. They apply to tip/perf/urgent. Arguably on the 3rd one really
should go into 3.5. The first, second and fourth patches should cleanly
to tip/perf/core. Hopefully the fourth patch walks an rbtree correctly.

David Ahern (4):
  perf kvm: set name for VM process in guest machine
  perf kvm: guest userspace samples should not be lumped with host uspace
  perf kvm: limit repetitive guestmount message to once
  perf kvm: fix bug resolving guest kernel syms

 tools/perf/util/map.c     |   44 ++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/map.h     |    1 +
 tools/perf/util/session.c |    5 ++++-
 3 files changed, 47 insertions(+), 3 deletions(-)

-- 
1.7.10.1

