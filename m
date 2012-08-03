Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2HCQcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:32:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab2HCQcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:32:41 -0400
Date: Fri, 3 Aug 2012 18:29:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ptrace: DEBUGCTLMSR_BTF fixes
Message-ID: <20120803162912.GA19767@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Ingo, could you take this into -tip as well?

The subject says "ptrace:", but we need these changes for uprobes.
Although (afaics) this fix makes sense by itself.

Assuming this series passes the review of course. And it would
be really nice if someone reviews 2/2, I am not confident that
I fully understand this DEBUGCTLMSR_BTF magic.



The next step will change uprobes to use the new helper and avoid
user_enable_single_step().

Oleg.

