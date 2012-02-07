Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab2BGJwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 04:52:23 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:57269
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756273Ab2BGJwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 04:52:21 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2dI9371I146fK1432N98dK4015Lzz1202hzzz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ0OR4-02-0C5-02
X-M-MSG: 
Message-ID: <4F30F44C.8090603@amd.com>
Date: Tue, 7 Feb 2012 17:52:12 +0800
From: Andiry Xu <andiry.xu@amd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Richard Farina <sidhayn@gmail.com>
CC: <sarah.a.sharp@linux.intel.com>, Larry Finger <Larry.Finger@lwfinger.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Question about error from xhci-hcd
References: <4F30BB0B.5060203@gmail.com>
In-Reply-To: <4F30BB0B.5060203@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Feb 2012 09:52:12.0671 (UTC) FILETIME=[2A6390F0:01CCE57E]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 01:47 PM, Richard Farina wrote:
> I apologize but I am having the same issue reported in this thread in
> December
> 
> [ 5077.573181] xhci_hcd 0000:0a:00.0: ERROR no room on ep ring
> 
> I saw no resolution on this issue so I figured I'd step up and see if
> you needed an active tester who could reproduce the issue.
> 
> I am running Gentoo with a 3.2.2 kernel.  I am able to run any kernel
> version you need, including random git trees and custom patches.  If you
> have not solved this yet, please allow me to be your test monkey. If you
> have solved this already then sorry for harming the signal to noise
> ratio, I could not a find a later message then the one below.
> 

You can try andiry-ring-expansion branch on Sarah's xhci git tree. It
contains bugs and I'm trying to fix that, but you can have a try.

Thanks,
Andiry

> 
> On 12/28/2011 10:30 PM, Andiry Xu wrote: 
>>
>> That's the error I want to see, but I didn't find it in the dmesg you 
>> posted. is it wrapped? 
>>
>> Anyway, please post the full dmesg with no room on ring error and the 
>> dump of the ep ring and event ring (so the xhci_debug_ring() is 
>> triggered in the patch), so we can see if the ring is mangled or there 
>> is just too many transfers. 
>>
>> Another thing you can try is the andiry-ring-expansion branch on Sarah's 
>> xhci git tree, check if there is still no room on ring error. 
> 
> No, the ring is not wrapped. I seems that my anti-spam mechanism kicked
> in too 
> soon. or the run stopped too soon. 
> 
> I'll have the OP do another run and see if we can get the right
> information. 
> 
> Larry 
> --
> 
> 


