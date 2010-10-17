Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab0JQJYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 05:24:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:35929 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310Ab0JQJYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 05:24:34 -0400
Message-ID: <4CBAC163.8020606@kernel.org>
Date: Sun, 17 Oct 2010 11:26:59 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Armin Schindler <armin@melware.de>
CC: Karsten Keil <isdn@linux-pingi.de>, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2.6.36-rc7] isdn/eicon: don't call flush_scheduled_work()
 from diva_os_remove_soft_isr()
References: <4CB84FAF.5080608@kernel.org> <alpine.DEB.2.00.1010161441040.27329@justus.melware.de> <4CB9A478.5040501@kernel.org> <alpine.DEB.2.00.1010170031270.29490@justus.melware.de>
In-Reply-To: <alpine.DEB.2.00.1010170031270.29490@justus.melware.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 17 Oct 2010 09:24:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2010 12:32 AM, Armin Schindler wrote:
>> Thank you.  Are you gonna route this patch or shall I push it through
>> wq tree?
> 
> It's your patch ;-)

Alright, queueing to wq#for-next w/ your acked-by.  Thank you.

-- 
tejun
