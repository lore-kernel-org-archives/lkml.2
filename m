Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab1G2R2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:28:50 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36655 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1G2R2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:28:49 -0400
Date: Fri, 29 Jul 2011 10:28:45 -0700 (PDT)
Message-Id: <20110729.102845.970754534713453670.davem@davemloft.net>
To: vitalivanov@gmail.com
Cc: rdunlap@xenotime.net, Trond.Myklebust@netapp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: xprt.c: htmldocs warning correction
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGTPOqdTxkFHxp-qNAMjg_YV91ZF2Fxze-HyV-TGsoF_r5ZyVQ@mail.gmail.com>
References: <1311959479.2242.41.camel@vivanov>
	<20110729.101515.1435434309123620862.davem@davemloft.net>
	<CAGTPOqdTxkFHxp-qNAMjg_YV91ZF2Fxze-HyV-TGsoF_r5ZyVQ@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 29 Jul 2011 10:28:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Fri, 29 Jul 2011 20:19:26 +0300

> On Fri, Jul 29, 2011 at 8:15 PM, David Miller <davem@davemloft.net> wrote:
>> From: Vitaliy Ivanov <vitalivanov@gmail.com>
>> Date: Fri, 29 Jul 2011 20:11:19 +0300
>>
>>> Add description for parameter 'xprt'.
>>>
>>> Warning(/net/sunrpc/xprt.c:196): No description found for parameter 'xprt'
>>>
>>> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
>>
>> There is already a fix for this from Randy Dunlap in my networking
>> GIT tree.
>>
> 
> OK, I found two other warning correction patches from Randy in list
> but not this one. Seems like I missed it.

He only posted it to netdev@vger.kernel.org
