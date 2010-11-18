Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557Ab0KRVPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:15:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58236
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759584Ab0KRVPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:15:03 -0500
Date: Thu, 18 Nov 2010 13:15:27 -0800 (PST)
Message-Id: <20101118.131527.45904827.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: kaber@trash.net, justinmattock@gmail.com, eric.dumazet@gmail.com,
        linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, horms@verge.net.au,
        netfilter-devel@vger.kernel.org
Subject: Re: error while building the kernel Mainline
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101118.131004.58430322.davem@davemloft.net>
References: <20101118.125451.98885354.davem@davemloft.net>
	<20101118130318.073f6beb.randy.dunlap@oracle.com>
	<20101118.131004.58430322.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 18 Nov 2010 13:10:04 -0800 (PST)

> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Thu, 18 Nov 2010 13:03:18 -0800
> 
>> On Thu, 18 Nov 2010 12:54:51 -0800 (PST) David Miller wrote:
>> 
>>> From: Patrick McHardy <kaber@trash.net>
>>> Date: Thu, 18 Nov 2010 21:32:11 +0100
>>> 
>>> > Thanks for testing. Dave, please apply directly, thanks!
>> 
>> Dave,
>> 
>> This patch does not fix the config/build error that I posted for linux-next.
> 
> And it has bugs, now when NF_CONNTRACT is set to "m" IPVS isn't offered
> at all.
> 
> So I'm reverting.

Ignore this, I was looking for "*_IPVS" in the config instead of
"*_IP_VS" for some stupid reason.

Patch is sane and I'll look into Randy's problem when I get a chance.
:-)
