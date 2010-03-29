Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab0C2MZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:25:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53920 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab0C2MZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:25:40 -0400
Message-Id: <20100329122021.765109681@chello.nl>
User-Agent: quilt/0.47-1
Date: Mon, 29 Mar 2010 14:20:21 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: [PATCH 0/2] perf: Use LBR for machine/oops debugging
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LBRs are relatively cheap to keep enabled and provide some history
to OOPSen, also some CPUs are reported to keep them over soft-reset,
which allows us to use them to debug things like tripple faults.

Therefore introduce a boot option: lbr_debug=on, which always enable
the LBRs and will print the LBRs on CPU init and die().

