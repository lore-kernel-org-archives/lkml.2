Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1HTTPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 15:15:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55815 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1HTTP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 15:15:29 -0400
MIME-Version: 1.0
In-Reply-To: <20110820174137.GA27243@infradead.org>
References: <4E4E6238.3080808@fusionio.com> <20110820174137.GA27243@infradead.org>
From: Mike Snitzer <snitzer@gmail.com>
Date: Sat, 20 Aug 2011 15:15:08 -0400
Message-ID: <CAMM=eLepBCf8T-ps-cGbnUphjt_cEkmcj8q4FLdO7_73OR0RQg@mail.gmail.com>
Subject: Re: [GIT PULL] block bits for 3.1-rc
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 1:41 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Aug 19, 2011 at 03:16:40PM +0200, Jens Axboe wrote:
>> - Revert of the CFQ meta data special treatment patch, it's been shown
>>   to regress a kernel build workload by about 10%. More investigation
>>   is needed, for 3.1 lets just back it out.
>
> Sorry, but you can't simply do that without any coordination.  We have
> added that marker to xfs now that the stupid special casing stopped,
> and turning it back on will cause us massive slowdows.  Next time
> please better coordinate this with its users.  In fact I have never
> seen this patch or a discussion on any mailinglist.

lkml.org archive doesn't have the full thread for some reason, but here it is:
http://www.gossamer-threads.com/lists/linux/kernel/1420370
