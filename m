Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab2GaCWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 22:22:37 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:22453
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476Ab2GaCWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 22:22:35 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI936eI1432Izz1202hzzz2fh2a8h668h839hf0ah107ah10d2h)
Message-ID: <50174158.4000408@am.sony.com>
Date: Mon, 30 Jul 2012 19:22:16 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "chris.pringle@miranda.com" <chris.pringle@miranda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RT 05/12] slab: Prevent local lock deadlock
References: <20120718223910.898476857@goodmis.org>	 <20120718223957.856443728@goodmis.org> <5011DD9B.1030901@am.sony.com> <1343697755.27983.17.camel@gandalf.stny.rr.com>
In-Reply-To: <1343697755.27983.17.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/12 18:22, Steven Rostedt wrote:
> On Thu, 2012-07-26 at 17:15 -0700, Frank Rowand wrote:
> 
>>
>> Config is from arch/arm/configs/omap2plus_defconfig
>> plus:
>>
>>    CONFIG_USB_EHCI_HCD=y
>>    CONFIG_USB_NET_SMSC95XX=y
>>    CONFIG_PREEMPT_RT_FULL=y
>>
> 
> Interesting, I just booted my panda board against 3.0.36-rt58 with that
> config and these three set, and I didn't get this error.

I don't know if it makes any difference, but my root fs is nfs mounted.

I'll try to look at this some more tomorrow.

-Frank

