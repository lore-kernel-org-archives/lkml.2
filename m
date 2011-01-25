Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1AYFH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 00:07:26 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39379 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1AYFHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 00:07:25 -0500
MIME-Version: 1.0
In-Reply-To: <20110124.210646.226764975.davem@davemloft.net>
References: <20110125044910.GB8117@infradead.org>
	<20110124.210543.193717502.davem@davemloft.net>
	<20110124.210646.226764975.davem@davemloft.net>
Date: Tue, 25 Jan 2011 13:07:24 +0800
Message-ID: <AANLkTimfrEXxJ2Vi31PZKWGvUL=O2v0eNt9tDhEr=fit@mail.gmail.com>
Subject: Re: net: clear heap allocation for ethtool_get_regs()
From: Eugene Teo <eugeneteo@kernel.sg>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        bhutchings@solarflare.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 1:06 PM, David Miller <davem@davemloft.net> wrote:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 24 Jan 2011 21:05:43 -0800 (PST)
>
>> From: Eugene Teo <eugeneteo@kernel.org>
>> Date: Tue, 25 Jan 2011 12:49:10 +0800
>>
>>> There is a conflict between commit b00916b1 and a77f5db3. This patch resolves
>>> the conflict by clearing the heap allocation in ethtool_get_regs().
>>>
>>> Cc: stable@kernel.org
>>> Signed-off-by: Eugene Teo <eugeneteo@kernel.org>
>>
>> Applied, thanks Eugene.
>
> Ugh, I just noticed, Eugene could you please always CC: netdev on
> networking patches?  Thanks.

Will do that. Thanks Dave.

Eugene
