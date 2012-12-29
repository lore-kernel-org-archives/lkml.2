Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab2L2Rhp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 12:37:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab2L2Rhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 12:37:43 -0500
Date: Sat, 29 Dec 2012 18:35:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] uprobes: Teach handler_chain() to filter out the
	probed task
Message-ID: <20121229173554.GA2145@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On top of "uprobes: pre-filtering".

Srikar, If you still disagree and prefer to use ->filter() in
handler_chain() please argue.

Note that unapply_uprobe() added by this patch can be generalized
to implement uprobe_apply(consumer, mm, is_register).

Oleg.

