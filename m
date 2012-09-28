Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab2I1Ijr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:39:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:56502 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308Ab2I1Ijo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:39:44 -0400
Message-ID: <5065622F.3040001@kernel.dk>
Date: Fri, 28 Sep 2012 10:39:11 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: NeilBrown <neilb@suse.de>, Shaohua Li <shli@fusionio.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: makes bio_split support bio without data
References: <20120924145639.3b65fd8b@notabene.brown> <5061A8EA.6040702@kernel.dk> <20120928073655.GA24681@kernel.org>
In-Reply-To: <20120928073655.GA24681@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-28 09:36, Shaohua Li wrote:
> On Tue, Sep 25, 2012 at 02:51:54PM +0200, Jens Axboe wrote:
>> On 09/24/2012 06:56 AM, NeilBrown wrote:
>>>
>>> Hi Jens,
>>>  this patch has been sitting in my -next tree for a little while and I was
>>>  hoping for it to go in for the next merge window.
>>>  It simply allows bio_split() to be used on bios without a payload, such as
>>>  'discard'.
>>>  Are you happy with it going in though my 'md' tree, or would you rather take
>>>  it though your 'block' tree?
>>
>> It should go through my tree, especially since we've got conflicts with
>> other changes. In other words, your patch does not apply to for-3.7/core
>> as-is...
>>
>> Shaohua, could you resend an updated variant?
> Here is the one applied to for-3.7/core

Thanks Shaohua, applied!

-- 
Jens Axboe

