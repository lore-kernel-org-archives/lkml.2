Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab0HLJpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 05:45:33 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:2922 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759254Ab0HLJpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 05:45:32 -0400
X-IronPort-AV: E=Sophos;i="4.55,357,1278280800"; 
   d="scan'208";a="67527458"
From: Tomasz Buchert <tomasz.buchert@inria.fr>
To: Matt Helsley <matthltc@us.ibm.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Tomasz Buchert <tomasz.buchert@inria.fr>
Subject: [PATCH 0/3] Two bugfixes for cgroup freezer. 
Date: Thu, 12 Aug 2010 11:45:20 +0200
Message-Id: <1281606323-16245-1-git-send-email-tomasz.buchert@inria.fr>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1281470001-14320-1-git-send-email-tomasz.buchert@inria.fr>
References: <1281470001-14320-1-git-send-email-tomasz.buchert@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fixes two bugs I discovered when working with
the cgroup freezer. These patches fix them (and probably also
some other variations of them) and now the kernel passes
testcases that uncovered the bugs in the first place.

Please review.

Tomasz

Tomasz Buchert (3):
  cgroup_freezer: Unnecessary test in cgroup_freezing_or_frozen
  cgroup_freezer: Fix can_attach to prohibit moving from/to
    freezing/frozen cgroups
  cgroup_freezer: update_freezer_state does incorrect state
    transactions

 kernel/cgroup_freezer.c |   74 +++++++++++++++++++++-------------------------
 1 files changed, 34 insertions(+), 40 deletions(-)

