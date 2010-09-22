Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab0IVUUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:20:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35008
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754240Ab0IVUUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:20:54 -0400
Date: Wed, 22 Sep 2010 13:21:13 -0700 (PDT)
Message-Id: <20100922.132113.115922473.davem@davemloft.net>
To: aaw@google.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        akpm@linux-foundation.org, davem@google.com
Subject: Re: [PATCH] Move "struct net" declaration inside the __KERNEL__
 macro guard
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTim3V4yp+_LY8iN3R0xhV8hpPw_7o-uqwPFqXokz@mail.gmail.com>
References: <AANLkTimRSjqewc_mC5vwdXy1t4Ax5rAf5svpOTbUEF7o@mail.gmail.com>
	<20100917.165120.139548355.davem@davemloft.net>
	<AANLkTim3V4yp+_LY8iN3R0xhV8hpPw_7o-uqwPFqXokz@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ollie Wild <aaw@google.com>
Date: Wed, 22 Sep 2010 10:54:54 -0500

> On Fri, Sep 17, 2010 at 6:51 PM, David Miller <davem@davemloft.net> wrote:
>>
>> From: Ollie Wild <aaw@google.com>
>> Date: Fri, 17 Sep 2010 14:38:59 -0500
>>
>> > (Resending with a proper signoff.)
>>
>> Your patch is still unusable because your email client white-space mangled
>> the patch, turning tabs into space characters.
>>
>> Please fix this up and resubmit, thanks.
> 
> Third time's a charm ...
> 
> Signed-off-by: Ollie Wild <aaw@google.com>

Applied, thanks.
