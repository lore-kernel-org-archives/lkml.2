Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab0HaBmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 21:42:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42583
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756544Ab0HaBmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 21:42:24 -0400
Date: Mon, 30 Aug 2010 18:42:40 -0700 (PDT)
Message-Id: <20100830.184240.58442478.davem@davemloft.net>
To: jengelh@medozas.de
Cc: agruen@suse.de, netfilter@vger.kernel.org, eparis@redhat.com,
        linux-kernel@vger.kernel.org, schwab@redhat.com, laforge@netfilter.org,
        andi@firstfloor.org
Subject: Re: aligned_{u64,be64,le64} defined in #ifdef __KERNEL__
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.01.1008301502280.19931@obet.zrqbmnf.qr>
References: <20100829.212156.229740543.davem@davemloft.net>
	<201008301258.33113.agruen@suse.de>
	<alpine.LNX.2.01.1008301502280.19931@obet.zrqbmnf.qr>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@medozas.de>
Date: Mon, 30 Aug 2010 15:02:55 +0200 (CEST)

> 
> On Monday 2010-08-30 12:58, Andreas Gruenbacher wrote:
>>
>>> If we want a version of this type visible to userspace, it needs to,
>>> for example, have double underscores prepended to the type name just
>>> as we do for things like __u16 and __u32.
>>
>>How about something like this?
> 
> 
> I like that approach:
> 

Me too.
