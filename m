Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2HIEoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 00:44:06 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59630 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab2HIEoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 00:44:03 -0400
Date: Thu, 9 Aug 2012 10:13:56 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, stan_shebs@mentor.com
Subject: Re: [PATCH 2/5] x86/uprobes: implement x86 specific
	arch_uprobe_*_step
Message-ID: <20120809044356.GA3163@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-3-git-send-email-bigeasy@linutronix.de> <20120808125709.GA4504@redhat.com> <50226700.9000606@linutronix.de> <20120808145345.GA8171@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808145345.GA8171@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080904-5112-0000-0000-00000AE29B2F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 04:53:45PM +0200, Oleg Nesterov wrote:
> On 08/08, Sebastian Andrzej Siewior wrote:

...

> >> ->insn[0] doesn't look right, we should skip the prefixes.

insn_init()
insn_get_opcode()
if (OPCODE1() == 0x9d)

is always the right way of doing it.

...

> And in any case it would be better to re-use auprobe->fixups.

Agreed.

Ananth

