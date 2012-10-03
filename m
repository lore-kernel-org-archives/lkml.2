Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab2JCOEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:04:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:44333 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab2JCOEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:04:49 -0400
Message-ID: <506C45D8.7000306@kernel.dk>
Date: Wed, 03 Oct 2012 16:04:08 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>
CC: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] drbd-8.3 updates
References: <8391701.3EY4hQfmFv@fat-tyre> <10403443.3yRLLBkj5b@fat-tyre> <506C343E.60203@kernel.dk> <1646250.CkOtqoMF8x@fat-tyre>
In-Reply-To: <1646250.CkOtqoMF8x@fat-tyre>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-03 15:49, Philipp Reisner wrote:
>> Thanks, one question before this is pulled in:
>>> Philipp Reisner (6):
>>>       drbd: Add a drbd directory to sysfs
>>>       drbd: expose the data generation identifiers via sysfs
>>
>> What are these? It's sitting in /sys/block/<dev>/drbd/, I don't see any
>> documentation or justification for that.
>>
>> Why isn't it off in debugfs or similar instead?
> 
> The long-time goal is to get rid of the /proc/drbd virtual file, and
> present the information that was there in a more structured way in /sys.
> 
> This patch adds a very first step into that direction. Later we intend to
> have here things like the connections state, device roles, statistics
> counters there.
> 
> When coming up with the layout we used the sysfs presence of software raid 
> as example.

Software raid is different, though, in that it's a class/type of device.
So for drbd, I'd still recommend you look outside of the regular
/sys/block hierarchy for adding something like this.

> I have removed it from this pull-request, so that there is more time for
> consideration before the next merge window.

Thanks, pulled.

-- 
Jens Axboe

