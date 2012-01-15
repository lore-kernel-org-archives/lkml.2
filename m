Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab2AOMWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 07:22:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:35639 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2AOMWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 07:22:11 -0500
Message-ID: <4F12C4ED.6060301@kernel.dk>
Date: Sun, 15 Jan 2012 13:22:05 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Subject: Re: [GIT PULL] Block drivers for 3.3-rc
References: <4F12A1CC.50105@kernel.dk> <20120115103331.GA31956@infradead.org>
In-Reply-To: <20120115103331.GA31956@infradead.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-15 11:33, Christoph Hellwig wrote:
> On Sun, Jan 15, 2012 at 10:52:12AM +0100, Jens Axboe wrote:
>> Hi Linus,
>>
>> Please see below for the 3.3-rc1 block driver pull request.
>>
>> Essentially two different categories here:
>>
>> - Adds the driver for the Micron RealSSD P320 pci-express flash card.
> 
> The REQ_FUA and REQ_FLUSH handling in it is still completely broken,
> with no attempt to fix it since it last came up.
> 
> So a pretty clear NAK on that driver from me.

Good point, I had forgotten about the ordered writes, I believe the rest
of the items have been handled. The driver/hw, as it stands, does not
reorder writes and it doesn't have a write back cache. So it should
actually be safe. Any acked write is stable. Sam, correct me if I'm
wrong.

-- 
Jens Axboe

