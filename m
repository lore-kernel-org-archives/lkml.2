Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027Ab0HFDUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 23:20:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38357 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab0HFDU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 23:20:28 -0400
Date: Fri, 06 Aug 2010 12:20:26 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: linux-next: manual merge of the input tree with the s5p tree
In-reply-to: <20100806114314.6d15d4fb.sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Message-id: <4C5B7F7A.1000707@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
References: <20100722114655.1140fb61.sfr@canb.auug.org.au>
 <20100806102419.3e875933.sfr@canb.auug.org.au>
 <004801cb3500$69824bd0$3c86e370$%kim@samsung.com>
 <20100806114314.6d15d4fb.sfr@canb.auug.org.au>
X-OriginalArrivalTime: 06 Aug 2010 03:20:26.0470 (UTC)
 FILETIME=[50677060:01CB3516]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/6/2010 10:43 AM, Stephen Rothwell wrote:
> Hi,
> 
> On Fri, 06 Aug 2010 09:43:34 +0900 Kukjin Kim <kgene.kim@samsung.com> wrote:
>> I know that Dmitry's 'Input: samsung-keypad...patch' which includes
>> plat/keypad.h has been merged Linus' tree in this merge window.
>> And Joonyoung's another patch which is in my tree needs to update it, but my
>> tree is don't having it against Linus' 2.6.35.
>>
>> So happened conflict...how can/should I handle this...
>> Should I rebase my tree against Linus' latest?
> 
> Either rebase (worst), or just merge Linus' tree (better) into yours or
> (best) merge what Dmitry merged into Linus' tree.  To do this last, you
> need to merge commit d01d0756f75e7a5b4b43764ad45b83c4340f11d6 from Linus'
> tree.  Doing this brings in the minimum amount of extra stuff to your
> tree, but allows you to sort out the conflict.
> 

Kukjin,

If you rebase and need, i can send updated patches. It uses "ARM:
SAMSUNG: Add helper to clone and set platform data" patch of Ben Dooks.

Thanks.
