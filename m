Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab2AOMug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 07:50:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:35832 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2AOMuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 07:50:35 -0500
Message-ID: <4F12CB96.4030704@kernel.dk>
Date: Sun, 15 Jan 2012 13:50:30 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Subject: Re: [GIT PULL] Block drivers for 3.3-rc
References: <4F12A1CC.50105@kernel.dk> <20120115103331.GA31956@infradead.org> <4F12C4ED.6060301@kernel.dk> <20120115124405.GA7389@infradead.org>
In-Reply-To: <20120115124405.GA7389@infradead.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-15 13:44, Christoph Hellwig wrote:
> On Sun, Jan 15, 2012 at 01:22:05PM +0100, Jens Axboe wrote:
>> Good point, I had forgotten about the ordered writes, I believe the rest
>> of the items have been handled. The driver/hw, as it stands, does not
>> reorder writes and it doesn't have a write back cache. So it should
>> actually be safe. Any acked write is stable. Sam, correct me if I'm
>> wrong.
> 
> I tried to get that out of the micron folks a while ago but don't
> remember getting an answer.  If that's actually tree please remove
> the (misnamed) barrier argument from mtip_hw_submit_io, and maybe add
> a comment that the current hardware can't have a volatile write cache.

Sure, will do post pull to not mess up the current pull request.

> Btw, does the hardware claim to have writeback caches in the ATA
> IDENTIFY words related to it?

I'll let Sam answer this one and the question above, it's better if it
comes from the source.

-- 
Jens Axboe

