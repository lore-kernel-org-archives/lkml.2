Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab0DHRiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:38:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758821Ab0DHRit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:38:49 -0400
Message-ID: <4BBE1473.5050206@redhat.com>
Date: Thu, 08 Apr 2010 13:37:55 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc14 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       Konrad Rzeszutek Wilk <konrad@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [LKML] Re: [PATCH 1/1] ibft, x86: Change reserve_ibft_region()
 to find_ibft_region()
References: <1270741936-1306-1-git-send-email-konrad@kernel.org> <1270741936-1306-2-git-send-email-konrad@kernel.org> <alpine.LFD.2.00.1004080852200.3558@i5.linux-foundation.org> <20100408161210.GA13382@phenom.dumpdata.com> <alpine.LFD.2.00.1004081027140.3558@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004081027140.3558@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 01:28 PM, Linus Torvalds wrote:
> 
> 
> On Thu, 8 Apr 2010, Konrad Rzeszutek Wilk wrote:
>>
>> Oh, I am definitely ACK-ing. Sorry about not explicitly stating that.
>> The developer is Yinghai Lu, I am the co-maintainer of the iBFT driver.
>>
>> Linus, would you like me to modify the commit so that it has 'Acked-by:'
>> by me in the git tree?
> 
> No, no, a sign-off is already an ack, and is "stronger" than an ack, since 
> it actually also means that you send it onwards. A patch that you don't 
> like you would obviously never sign off on either.
> 
> I was more looking for comments from other people who know what the heck 
> that early reservation system does.

Just for the record, it also looks good to me (the other co-maintainer), so:

Signed-Off-By: Peter Jones <pjones@redhat.com>

But obviously that doesn't actually constitute the acks you were /looking/
for.

-- 
        Peter

What we need is either less corruption, or more chances to
participate in it.
