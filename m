Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab1A1Bg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 20:36:29 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:26892 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752715Ab1A1Bg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 20:36:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAMesQU1Ld/sX/2dsb2JhbAAMhAjNIJBcgSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,388,1291611600"; 
   d="scan'208";a="89495020"
Message-ID: <4D421D9A.50007@teksavvy.com>
Date: Thu, 27 Jan 2011 20:36:26 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Stan Hoeppner <stan@hardwarefreak.com>,
        Justin Piszcz <jpiszcz@lucidpixels.com>,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard> <4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com> <alpine.DEB.2.00.1101271040000.31246@p34.internal.lan> <4D419765.4070805@teksavvy.com> <4D41CA16.8070001@hardwarefreak.com> <4D41EA04.7010506@teksavvy.com> <20110128001735.GO21311@dastard> <4D421A68.9000607@teksavvy.com>
In-Reply-To: <4D421A68.9000607@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-27 08:22 PM, Mark Lord wrote:
> On 11-01-27 07:17 PM, Dave Chinner wrote:
>>
>> In my experience with XFS, most people who tweak mkfs parameters end
>> up with some kind of problem they can't explain and don't know how
>> to solve. And they are typically problems that would not have
>> occurred had they simply used the defaults in the first place. What
>> you've done is a perfect example of this.
> 
> Maybe.  But what I read from the paragraph above,
> is that the documentation could perhaps explain things better,
> and then people other than the coders might understand how
> best to tweak it.


By the way, the documentation is excellent, for a developer who
wants to work on the codebase.  It describes the data structures
and layouts etc.. better than perhaps any other Linux filesystem.

But it doesn't seem to describe the algorithms, such as how it
decides where to store a recording stream.

I'm not complaining, far from it.  XFS is simply wonderful,
and my DVR literally couldn't work without it.

But I am as technical as you are, and I like to experiment and
understand the technology I use.  That's partly why we both work
on the Linux kernel.

Cheers
