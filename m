Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab0JPNJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 09:09:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:42249 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab0JPNJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 09:09:33 -0400
Message-ID: <4CB9A478.5040501@kernel.org>
Date: Sat, 16 Oct 2010 15:11:20 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Armin Schindler <armin@melware.de>
CC: Karsten Keil <isdn@linux-pingi.de>, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2.6.36-rc7] isdn/eicon: don't call flush_scheduled_work()
 from diva_os_remove_soft_isr()
References: <4CB84FAF.5080608@kernel.org> <alpine.DEB.2.00.1010161441040.27329@justus.melware.de>
In-Reply-To: <alpine.DEB.2.00.1010161441040.27329@justus.melware.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 16 Oct 2010 13:08:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/16/2010 02:42 PM, Armin Schindler wrote:
> On Fri, 15 Oct 2010, Tejun Heo wrote:
>> diva doesn't use workqueue and there is no reason to flush the system
>> workqueue from diva_os_remove_soft_isr().  Remove it.
>>
>> This is to prepare for the deprecation and removal of
>> flush_scheduled_work().
> 
> This is a leftover. Thanks.
> 
> Acked-by: Armin Schindler <armin@melware.de>

Thank you.  Are you gonna route this patch or shall I push it through
wq tree?

-- 
tejun
