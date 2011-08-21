Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab1HUKSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 06:18:45 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42124 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab1HUKSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 06:18:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6444"; a="111841764"
Message-ID: <7e62861a4ff90aa7990dda5563340797.squirrel@www.codeaurora.org>
In-Reply-To: <20110818224713.GA6738@xanatos>
References: <20110818224713.GA6738@xanatos>
Date: Sun, 21 Aug 2011 03:18:34 -0700 (PDT)
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to 
     devio.c
From: "Amit Blay" <ablay@codeaurora.org>
To: "Sarah Sharp" <sarah.a.sharp@linux.intel.com>
Cc: "Amit Blay" <ablay@codeaurora.org>,
        "Hans Petter Selasky" <hselasky@c2i.net>,
        "Tatyana Brokhman" <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        "Amit Blay" <ablay@qualcomm.com>,
        "open list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Sarah, Hans for your comments,

On Thu, August 18, 2011 3:47 pm, Sarah Sharp wrote:

> Yes, I think this is the correct solution.  Sorry for taking so long to
> get back to you.

OK, so I will go ahead with implementing this solution.

> On Wed, Aug 17, 2011 at 09:06:03AM +0200, Hans Petter Selasky wrote:
>> I would suggest overloading the "unsigned int pipe", instead of breaking
>> existing API's by adding a new stream ID value. Also for LibUSB.

The purposed solution will not break any existing API, by doing the
following:
a. Adding a new API for streams alloc/dealloc
b. Adding a new API for submitting a URB which is stream capable (I will
implement this in a separate patch).

> I don't see this as a strong argument why we should arbitrarily limit a
> new API.  It's very hard to deprecate kernel to userspace API, so I
> think we should do it right the first time.  There are current
> applications (like an SSD behind a UAS device) that need as many
> concurrent streams in flight as possible, so I don't buy the argument
> that there aren't current applications that need that many streams.

I agree with Sarah.
Hans, I appreciate your inputs. Please let me know if you see a good
reason why not implementing the new APIs purposed above for streams
allocation and usage. Otherwise I will go ahead with the implementation.

Thanks,
Amit.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

