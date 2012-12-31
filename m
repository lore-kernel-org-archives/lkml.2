Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab2LaRwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 12:52:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab2LaRwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 12:52:14 -0500
Date: Mon, 31 Dec 2012 18:51:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] uprobes: alloc utask/xol_area cleanups and minor fix
Message-ID: <20121231175150.GA32066@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This series fixes the minor bug and cleanups the usage of add_utask()
and xol_alloc_area(). Plus it cleanups the initializaion of ->utask
in handle_swbp() paths.

Anton, this conflicts with your uretprobe patches, but I think we
should do this to avoid the code duplication. IOW, I consider this
series as a minor preparations for uretprobes as well.

Oleg.

 kernel/events/uprobes.c |  150 +++++++++++++++++++++--------------------------
 1 files changed, 68 insertions(+), 82 deletions(-)

