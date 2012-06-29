Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab2F2QLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:11:03 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:39014
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751727Ab2F2QLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:11:01 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I1521I1432Izz1202hzzz2dh2a8h668h839h93fhd25he5bhf0ah)
Message-ID: <4FEDD383.40804@freescale.com>
Date: Fri, 29 Jun 2012 11:10:43 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Timur Tabi <b04825@freescale.com>
CC: Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com> <CAOZdJXWiGOCtP1iJYR2S48XwR2Wpry8+VswctctdVfY9Z+QTiQ@mail.gmail.com> <4FEDD07D.3090103@freescale.com> <4FEDD1F0.1060000@freescale.com>
In-Reply-To: <4FEDD1F0.1060000@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 11:04 AM, Timur Tabi wrote:
> Scott Wood wrote:
> 
>>> I wonder if it's possible to dynamically generate the compatible
>>> string by using the SOC name?
>>
>> Where are you going to get the SoC name from?
> 
> Well, that is why I said "I wonder".   I'm disappointed that the "cpus"
> node doesn't help much.  You'd think the name of the CPU would be in the
> CPU node somewhere.

The SoC is not the CPU.  The CPU is e500v2.

Why is this different from anywhere else where we have a list of
compatibles to match, often based on various SoCs?  Note that we
explicitly want to match only certain SoCs here.

-Scott

