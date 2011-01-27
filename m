Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab1A0QDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 11:03:54 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:18606 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751291Ab1A0QDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 11:03:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAAQmQU1Ld/sX/2dsb2JhbAAMhAjMcJBfgSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,386,1291611600"; 
   d="scan'208";a="89426373"
Message-ID: <4D419765.4070805@teksavvy.com>
Date: Thu, 27 Jan 2011 11:03:49 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Stan Hoeppner <stan@hardwarefreak.com>,
        Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alex Elder <aelder@sgi.com>
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard> <4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com> <alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-27 10:40 AM, Justin Piszcz wrote:
> 
> 
> On Thu, 27 Jan 2011, Mark Lord wrote:
..
>> Can you recommend a good set of mkfs.xfs parameters to suit the characteristics
>> of this system?  Eg. Only a few thousand active inodes, and nearly all files are
>> in the 600MB -> 20GB size range.  The usage pattern it must handle is up to
>> six concurrent streaming writes at the same time as up to three streaming reads,
>> with no significant delays permitted on the reads.
>>
>> That's the kind of workload that I find XFS handles nicely,
>> and EXT4 has given me trouble with in the past.
..
> I did a load of benchmarks a long time ago testing every mkfs.xfs option there
> was, and I found that most of the time (if not all), the defaults were the best.
..

I am concerned with fragmentation on the very special workload in this case.
I'd really like the 20GB files, written over a 1-2 hour period, to consist
of a very few very large extents, as much as possible.

Rather than hundreds or thousands of "tiny" MB sized extents.
I wonder what the best mkfs.xfs parameters might be to encourage that?

Cheers
