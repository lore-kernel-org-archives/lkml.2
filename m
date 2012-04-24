Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab2DXCSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 22:18:07 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34375 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297Ab2DXCSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 22:18:05 -0400
Date: Mon, 23 Apr 2012 22:15:52 -0400 (EDT)
Message-Id: <20120423.221552.1200047689249251213.davem@davemloft.net>
To: rdunlap@xenotime.net
Cc: ebiederm@xmission.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org, ralf@linux-mips.org
Subject: Re: [PATCH] net ax25: Fix the build when sysctl support is
 disabled.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F9601CD.2070000@xenotime.net>
References: <4F95828A.8050403@xenotime.net>
	<m1obqirn5e.fsf_-_@fess.ebiederm.org>
	<4F9601CD.2070000@xenotime.net>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 23 Apr 2012 19:15:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Mon, 23 Apr 2012 18:28:45 -0700

> On 04/23/2012 05:25 PM, Eric W. Biederman wrote:
> 
>> 
>> Randy Dunlap <rdunlap@xenotime.net> reported:
>> 
>>> On 04/23/2012 12:07 AM, Stephen Rothwell wrote:
>>>
>>>> Hi all,
>>>>
>>>> Changes since 20120420:
>>>
>>>
>>> include/net/ax25.h:447:75: error: expected ';' before '}' token
>>>
>>> static inline int ax25_register_dev_sysctl(ax25_dev *ax25_dev) { return 0 };
>>> static inline void ax25_unregister_dev_sysctl(ax25_dev *ax25_dev) {};
>>>
>>> First function:  move ';' inside braces.
>>> Second function:  drop the ';'.
>> 
>> Put the semicolons where it makes sense.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> 
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Applied, thanks guys.
