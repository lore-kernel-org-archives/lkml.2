Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab2KIQXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:23:55 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49769 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab2KIQXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:23:52 -0500
Message-ID: <509D2DF8.4030602@oracle.com>
Date: Fri, 09 Nov 2012 11:23:20 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121024 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: use BUG_ON where possible
References: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com> <1352406191-14303-2-git-send-email-sasha.levin@oracle.com> <alpine.LNX.2.00.1211082242130.27271@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1211082242130.27271@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On 11/08/2012 04:42 PM, Jiri Kosina wrote:
> On Thu, 8 Nov 2012, Sasha Levin wrote:
> 
>> Just use BUG_ON() instead of constructions such as:
>>
>> 	if (...)
>> 		BUG()
>>
>> A simplified version of the semantic patch that makes this transformation
>> is as follows: (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> expression e;
>> @@
>> - if (e) BUG();
>> + BUG_ON(e);
> 
> Ok, I guess I am just going to apply this one. Thanks,
> 

So I have about 80 more of these. I've sent out the first 10 to make sure
that they look fine and the only complaints I got about them are that they are
trivial :)

Can I send the rest directly to you to go through the trivial tree?


Thanks,
Sasha
