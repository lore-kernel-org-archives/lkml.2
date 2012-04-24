Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab2DXWFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:05:22 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:29233
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757877Ab2DXWFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:05:21 -0400
X-SpamScore: -14
X-BigFish: VS-14(zzbb2dI9371I936eK1432N98dKzz1202hzz8275dhz2dh2a8h668h839hd25he5bh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F972380.6030202@freescale.com>
Date: Tue, 24 Apr 2012 17:04:48 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] powerpc/8xx: Fix NR_IRQ bugs and refactor 8xx
 interrupt controller
References: <1335220202-32533-1-git-send-email-grant.likely@secretlab.ca> <1335220202-32533-2-git-send-email-grant.likely@secretlab.ca> <1335237195.24897.0.camel@pasglop> <OF4123672B.F86C969F-ONC12579EA.002A2C1F-C12579EA.002A48C2@transmode.se> <1335266570
In-Reply-To: <1335266570.15830.11.camel@pasglop>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 06:22 AM, Benjamin Herrenschmidt wrote:
> On Tue, 2012-04-24 at 09:41 +0200, Joakim Tjernlund wrote:
>> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote on 2012/04/24 05:13:15:
>>>
>>> On Mon, 2012-04-23 at 16:30 -0600, Grant Likely wrote:
>>>> The mpc8xx driver uses a reference to NR_IRQS that is buggy.  It uses
>>>> NR_IRQs for the array size of the ppc_cached_irq_mask bitmap, but
>>>> NR_IRQs could be smaller than the number of hardware irqs that
>>>> ppc_cached_irq_mask tracks.
>>>
>>> Joakim, any chance you can test this ASAP ? :-)
>>
>> Sorry, but no.  We have not moved our 8xx boards to 3.x as it in maintenance
>> and takes too much space.
> 
> Ah ok... Anybody else on the list who still has some 8xx gear ?

Boots OK on ep88xc.

-Scott

