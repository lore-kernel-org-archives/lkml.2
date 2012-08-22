Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab2HVOMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:12:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:47031 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2HVOL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:11:58 -0400
Message-ID: <5034E8A5.2060701@linutronix.de>
Date: Wed, 22 Aug 2012 16:11:49 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, stan_shebs@mentor.com
Subject: Re: [PATCH v3] x86/uprobes: implement x86 specific arch_uprobe_*_step
References: <1344355952-2382-3-git-send-email-bigeasy@linutronix.de> <20120808125709.GA4504@redhat.com> <50226700.9000606@linutronix.de> <20120808145345.GA8171@redhat.com> <20120809044356.GA3163@in.ibm.com> <20120809170953.GA27835@linutronix.de> <20120813132443.GB5269@redhat.com> <502A0C43.2000906@linutronix.de> <20120814142736.GA8123@redhat.com> <20120820104734.GA17034@linutronix.de> <20120822140337.GB28878@redhat.com>
In-Reply-To: <20120822140337.GB28878@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 04:03 PM, Oleg Nesterov wrote:
> On 08/20, Sebastian Andrzej Siewior wrote:
>>
>> The arch specific implementation behaves like user_enable_single_step()
>> except that it does not disable single stepping if it was already
>> enabled.
>
> Sebastian, we have other uprobes patches in flight, I'll returns to
> this after we push them.
>
> As I said, personally I mostly agree with this change... but may be
> I'll try to convince you to make v4 ;)

Ehm. Is there anything I missed to do? Or are you speculating on
changes which will clash with these here?

>
> Oleg.
>

Sebastian
