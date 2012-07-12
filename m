Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab2GLRMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:12:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254Ab2GLRMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:12:41 -0400
Date: Thu, 12 Jul 2012 19:09:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] uprobes: vma_address() fixlets
Message-ID: <20120712170934.GA25455@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Another series with small fixes/cleanups, on top of
"uprobes: teach build_probe_list() to consider the range"
(still waiting for review from Srikar).

4/4 was previously nacked by Anton because vma_address()
conflicts with rmap.c. Now that 3/4 renames this helper
it is "safe" to incluse mm/internal.h, so I re-send this
patch (unchanged).

Oleg.

