Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab2GBUkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 16:40:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:32254 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab2GBUkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 16:40:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="160677094"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: x86@kernel.org, eranian@google.com, linux-kernel@vger.kernel.org
Subject: Another IvyBridge/SandyBridge patchkit
Date: Mon,  2 Jul 2012 13:40:41 -0700
Message-Id: <1341261646-3171-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combined IvyBridge and SandyBridge PEBS perf series.

- Now with IvyBridge backend event readded as Peter requested.
This only changes the IvyBridge base patch, but since some
of the other patches depend on it I'm resending the full rebased
series
- PDIR is unchanged since it was unclear what to change.
If it's deemed controversial it can be removed.

Please consider applying,

-Andi

