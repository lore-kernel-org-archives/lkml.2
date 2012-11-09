Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab2KIM44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 07:56:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:60031 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2KIM4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 07:56:55 -0500
Message-ID: <509CFD70.5020807@kernel.dk>
Date: Fri, 09 Nov 2012 13:56:16 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>
CC: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] drbd-8.4.2 for the linux-3.8 merge window
References: <3042269.jrNem7z1LI@fat-tyre> <509CEB9F.8080705@kernel.dk> <4229483.8Hqs9YQUgX@fat-tyre>
In-Reply-To: <4229483.8Hqs9YQUgX@fat-tyre>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-09 13:42, Philipp Reisner wrote:
> [...]
>>> It has the sysfs bits in again. The reason for that is that we want to
>>> expose more information by that, and remove the /proc/drbd with the
>>> next evolutionary step. -- In case this is a show stopper, let me
>>> remove the sysfs bits.
>>
>> The exact same sysfs bits I complained about last time? If yes, then I
>> don't understand why you haven't changed yet. Or why you are trying to
>> push the same bits again that got rejected last time.
>>
> 
> I had the impression it was rejected because I submitted the pull request
> too late to you. In the sense of, it might go in, if it gets submitted
> for inclusion before the merge window opens...
> Apparently my impression was wrong. You will get an updated pull-request 
> with the sysfs bits removed

It was late, but that was a different issue. I just re-read the Oct 3rd
emails on this, and I definitely did recommend that you looked at
debugfs or similar for this. We're not putting another top-queue level
directory in for a block device that is specific to drbd.

-- 
Jens Axboe

