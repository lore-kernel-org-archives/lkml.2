Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1BYEGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 23:06:16 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16004 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab1BYEGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 23:06:15 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6267"; a="76369615"
From: David Brown <davidb@codeaurora.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Dima Zavin <dima@android.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Kenneth Heitke <kheitke@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        tsoni@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        swetland@google.com
Subject: Re: [PATCH v2 2/2] msm: add single-wire serial bus interface (SSBI) driver
References: <1298585954-22422-1-git-send-email-kheitke@codeaurora.org>
	<1298585954-22422-3-git-send-email-kheitke@codeaurora.org>
	<1298600621.17118.27.camel@m0nster>
	<8yad3mgdeut.fsf@huya.qualcomm.com>
	<1298601346.17118.29.camel@m0nster>
	<AANLkTikD1Ued=rit1QbMWwe3NGFz2iQ-KO7B=-N6Ok-2@mail.gmail.com>
	<8ya8vx4dcky.fsf@huya.qualcomm.com> <20110225032856.GA8475@suse.de>
	<8yavd08bwgi.fsf@huya.qualcomm.com> <20110225035857.GA9985@suse.de>
X-Hashcash: 1:20:110225:dima@android.com::GlqaZ2Sq9FcDQEyM:00nJz
X-Hashcash: 1:20:110225:linux-arm-kernel@lists.infradead.org::IFdEpVVW6XLDvwJ6:000000000000000000000000016lt
X-Hashcash: 1:20:110225:gregkh@suse.de::JPlwbxPJATvgcmi8:0002FdB
X-Hashcash: 1:20:110225:kheitke@codeaurora.org::XeQmqTXrw7RVN8AZ:0000000000000000000000000000000000000001tAX
X-Hashcash: 1:20:110225:linux-arm-msm@vger.kernel.org::s0rrckbUIVo61uhx:0000000000000000000000000000000060Xj
X-Hashcash: 1:20:110225:dwalker@fifo99.com::oRDv0YypTbAcQaRK:00000000000000000000000000000000000000000003gSR
X-Hashcash: 1:20:110225:linux-kernel@vger.kernel.org::vYmZCsE//5ehUAG+:0000000000000000000000000000000005Y6Q
X-Hashcash: 1:20:110225:tsoni@codeaurora.org::/PnZYUivwu7mBPsy:000000000000000000000000000000000000000006WRH
X-Hashcash: 1:20:110225:swetland@google.com::wjSUPsQbhydKFFrf:0000000000000000000000000000000000000000004wp2
Date: Thu, 24 Feb 2011 20:06:11 -0800
In-Reply-To: <20110225035857.GA9985@suse.de> (Greg KH's message of "Thu, 24
	Feb 2011 19:58:57 -0800")
Message-ID: <8yar5awbvws.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24 2011, Greg KH wrote:

> On Thu, Feb 24, 2011 at 07:54:21PM -0800, David Brown wrote:
>> On Thu, Feb 24 2011, Greg KH wrote:
>> 
>> > drivers/ssbi?  What's keeping this from later moving off of the msm
>> > chips to run on others?  USB started out only on one processor, as did a
>> > lot of other bus-specific drivers, before the hardware became present on
>> > other architectures.  So no need to bury it under a msm specific
>> > location.
>> 
>> Not sure if anything is stopping it from moving off of MSM chips, but it
>> doesn't seem very likely.  There are too many similar interfaces that
>> are standard that others would be likely to use.  For the most part, it
>> is the bus to communicate between the MSM and it's specialized
>> peripherals.
>> 
>> We can still put it there, but it will likely be the only driver ever in
>> the directory.
>
> Ah, so it's just one driver?  Then how about drivers/platform/msm/ ?

I like it.  It keeps drivers from getting cluttered.  Plus x86 is
getting lonely in there.

Ken, in addition to addressing the comments made so far and any others
that come in, let's put this under drivers/platform/msm.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
