Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab2LSQCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:02:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22933 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2LSQCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:02:15 -0500
Message-ID: <50D1E4EB.6000200@oracle.com>
Date: Wed, 19 Dec 2012 11:01:47 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at block/genhd.c:1574 disk_clear_events()
References: <20121219095241.GA27310@localhost> <20121219095632.GA27488@localhost>
In-Reply-To: <20121219095632.GA27488@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 04:56 AM, Fengguang Wu wrote:
> Sasha,
> 
> However note that this warning does not show up in next-20121219.
> 
> Thanks,
> Fengguang
> 
> On Wed, Dec 19, 2012 at 05:52:41PM +0800, Fengguang Wu wrote:
>> Hi Sasha,
>>
>> I got the below warning and it's bisected to
>>
>> commit 42f8570f437b65aaf3ef176a38ad7d7fc5847d8b
>> Author: Sasha Levin <sasha.levin@oracle.com>
>> Date:   Mon Dec 17 10:01:23 2012 -0500
>>
>>     workqueue: use new hashtable implementation

Hi Fengguang,

I'm slightly confused here: afaik what you're testing is Linus's git HEAD, right? (I
got that from 3.7.0-01930-gbff6343).

Tejun stated that he queued that commit for 3.9, and indeed I don't see it in Linus's
master as of today.

Therefore, I'm not quite sure how you're hitting it in your bisection - the only place
that commit is supposed to be at is in Tejun's -next/linux-next trees.


Thanks,
Sasha
