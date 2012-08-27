Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2H0Wy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 18:54:56 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:41405
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752652Ab2H0Wyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 18:54:54 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z21eIzbb2dI98dI1432Izz1202hzzz2fh2a8h668h839hd25hf0ah107ah10d2h1155h)
Message-ID: <503BFAB8.4070708@am.sony.com>
Date: Mon, 27 Aug 2012 15:54:48 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, <michael.thalmeier@hale.at>
Subject: Re: [PATCH RT 0/2] [ANNOUNCE] 3.0.41-rt62-rc1 stable review
References: <20120825034900.144648579@goodmis.org>
In-Reply-To: <20120825034900.144648579@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/12 20:49, Steven Rostedt wrote:
> 
> Dear RT Folks,
> 
> This is the RT stable review cycle of patch 3.0.41-rt62-rc1.
> 
> Please scream at me if I messed something up. Please test the patches too.

I should have looked harder when Michael requested my patch be applied to the
stable series.

My patch was part of a two patch series, sent 5/16.  The first patch was
a reversal of preempt-rt-allow-immediate-magic-sysrq-output-for-preempt_rt_full.patch

The second patch works fine without the first patch.  But the second patch (the one
in 3.0.41-rt62-rc1) removes the need for
preempt-rt-allow-immediate-magic-sysrq-output-for-preempt_rt_full.patch

It is not a big deal if the reversal patch gets left out of the stable releases,
but it is cleaner if it is included.

This also applies to 3.2.28-rt42-rc1

< snip >

> Changes from 3.0.41-rt61:
> 
> ---
> 
> 
> Frank Rowand (1):
>       fix printk flush of messages
> 
> Steven Rostedt (1):
>       Linux 3.0.41-rt62-rc1
> 
> ----
>  kernel/printk.c |    2 +-
>  localversion-rt |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

-Frank

