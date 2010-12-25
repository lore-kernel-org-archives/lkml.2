Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab0LYSlB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 13:41:01 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3880 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab0LYSk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 13:40:59 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6207"; a="68042057"
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH 1/7] msm: io: I/O register definitions for MSM8960
In-Reply-To: <201012241429.28901.arnd@arndb.de> (Arnd Bergmann's message of
	"Fri, 24 Dec 2010 14:29:28 +0100")
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	<201012152337.19475.arnd@arndb.de>
	<20101217001658.GA5880@huya.qualcomm.com>
	<201012241429.28901.arnd@arndb.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Sat, 25 Dec 2010 10:40:58 -0800
Message-ID: <8yaaajtd7b9.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Friday 17 December 2010, David Brown wrote:

>> My question, then is, should we hold off on getting 8960 support into
>> the kernel until enough things are improved to get rid of the 8960
>> ifdefs?  We can certainly do it that way, but it will keep the code
>> out of the kernel longer.
>
> My personal recommendation would be to fix all the places that you
> can do without significant reworks of the existing code, and
> just add TODO comments in the other places, so we can find them
> easily. There is no reason to hold up merging the code too long for
> this, but I wouldn't add code now that I know needs to be changed
> soon to something that can already be done easily.

Sounds like a good plan.  I've already started going through the IO
mapping defines to make them not-ifdef based.  It's not that significant
of a change.  Of course, everyone is on break here who will be able to
test things, so we'll have this stuff early January.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
