Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab2HVQEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:04:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab2HVQEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:04:00 -0400
Date: Wed, 22 Aug 2012 17:59:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, stan_shebs@mentor.com
Subject: Re: [PATCH v3] x86/uprobes: implement x86 specific
	arch_uprobe_*_step
Message-ID: <20120822155943.GA4237@redhat.com>
References: <50226700.9000606@linutronix.de> <20120808145345.GA8171@redhat.com> <20120809044356.GA3163@in.ibm.com> <20120809170953.GA27835@linutronix.de> <20120813132443.GB5269@redhat.com> <502A0C43.2000906@linutronix.de> <20120814142736.GA8123@redhat.com> <20120820104734.GA17034@linutronix.de> <20120822140337.GB28878@redhat.com> <5034E8A5.2060701@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5034E8A5.2060701@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Sebastian Andrzej Siewior wrote:
>
> On 08/22/2012 04:03 PM, Oleg Nesterov wrote:
>>
>> Sebastian, we have other uprobes patches in flight, I'll returns to
>> this after we push them.
>>
>> As I said, personally I mostly agree with this change... but may be
>> I'll try to convince you to make v4 ;)
>
> Ehm. Is there anything I missed to do? Or are you speculating on
> changes which will clash with these here?

If we have task_set_blockstep(), then perhaps it mmakes sense to
avoid user_enable_singlestep()/TIF_SINGLESTEP from the start.
We will see.

Oleg.

