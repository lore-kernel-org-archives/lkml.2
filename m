Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab1FQAWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 20:22:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab1FQAWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 20:22:13 -0400
Message-ID: <4DFA9E32.1080700@redhat.com>
Date: Thu, 16 Jun 2011 20:22:10 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kyle McMartin <kyle@redhat.com>
Subject: Re: SLUB BUG: check_slab called with interrupts enabled
References: <4DF8C80F.7090403@redhat.com> <alpine.DEB.2.00.1106150959500.768@router.home> <4DF8CCE1.80400@redhat.com> <alpine.DEB.2.00.1106151040020.768@router.home> <4DF9F84B.7040007@redhat.com> <alpine.DEB.2.00.1106161056450.3738@router.home>
In-Reply-To: <alpine.DEB.2.00.1106161056450.3738@router.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 11:57 AM, Christoph Lameter wrote:
> On Thu, 16 Jun 2011, Rik van Riel wrote:
>
>> After backing them out, I got 18 hours of uptime so far.
>>
>> This could just be dumb luck, or it could be some slub vs. kswapd
>> interaction.  Or maybe I simply am not triggering the original
>> bug any more because kswapd is now doing all the work, but may
>> still be able to trigger it under more memory pressure...
>
> Could be some memory issue or stack corruption. This is a machine with ECC
> ram right?

Yes it is, 12GB of ECC memory.

Running that much without ECC is probably a bad idea :)

>> Either way, since this could still be dumb luck, I'll let you
>> guys know if/when I see a next crash :)
>
> OK.

30 hours uptime already.

Just a little beyond the "dumb luck" threshold.

However, I suspect the bug may still be there and
the fact that kswapd is doing more work may simply
be hiding it.

-- 
All rights reversed
