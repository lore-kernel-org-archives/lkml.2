Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab1LLRuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:50:35 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:1676 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab1LLRue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:50:34 -0500
Subject: [PATCH 0/2] SYSCTL: export root handling routines
To: mingo@elte.hu
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: a.p.zijlstra@chello.nl, xemul@parallels.com, drosenberg@vsecurity.com,
        linux-kernel@vger.kernel.org, eparis@redhat.com, bfields@fieldses.org,
        jbottomley@parallels.com, akpm@linux-foundation.org, devel@openvz.org
Date: Mon, 12 Dec 2011 21:49:49 +0300
Message-ID: <20111212174709.7084.54702.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These rouitines are required to make SUNRPC sysctl's network-namespace-aware.

The following series consists of:

---

Stanislav Kinsbursky (2):
      SYSCTL: root unregister routine introduced
      SYSCTL: export root register and unregister routines


 kernel/sysctl.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)


