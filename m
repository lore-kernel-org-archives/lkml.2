Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2DWX0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 19:26:52 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33332 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab2DWX0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:26:50 -0400
Date: Mon, 23 Apr 2012 19:24:42 -0400 (EDT)
Message-Id: <20120423.192442.379812896211622385.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: ebiederm@xmission.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net sysctl: Add place holder functions for when sysctl
 support is compiled out of the kernel.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F95D9F5.3040407@xenotime.net>
References: <4F958598.6080305@xenotime.net>
	<m1lilmt7v5.fsf_-_@fess.ebiederm.org>
	<4F95D9F5.3040407@xenotime.net>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 23 Apr 2012 16:24:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Mon, 23 Apr 2012 15:38:45 -0700

> On 04/23/2012 03:13 PM, Eric W. Biederman wrote:
> 
>> 
>> Randy Dunlap <rdunlap@xenotime.net> reported:
>>> On 04/23/2012 12:07 AM, Stephen Rothwell wrote:
>>>
>>>> Hi all,
>>>>
>>>> Changes since 20120420:
>>>
>>>
>>>
>>> ERROR: "unregister_net_sysctl_table" [net/phonet/phonet.ko] undefined!
>>> ERROR: "register_net_sysctl" [net/phonet/phonet.ko] undefined!
>>>
>>> when CONFIG_SYSCTL is not enabled.
>> 
>> Add static inline stub functions to gracefully handle the case when sysctl
>> support is not present.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> 
> 
> Yep, that works.
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Applied, thanks everyone.
