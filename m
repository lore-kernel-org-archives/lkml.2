Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab1BWARX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 19:17:23 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36230 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab1BWARV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 19:17:21 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6265"; a="75852994"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Dima Zavin <dima@android.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        Kenneth Heitke <kheitke@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
        tsoni@codeaurora.org, linux-arm-msm@vger.kernel.org,
        ARM PORT <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] msm: add single-wire serial bus interface (SSBI) driver
References: <1297989299-27320-1-git-send-email-kheitke@codeaurora.org>
	<1297989432.9680.50.camel@c-dwalke-linux.qualcomm.com>
	<4D5DC289.1090004@codeaurora.org>
	<1298054771.17758.1.camel@c-dwalke-linux.qualcomm.com>
	<AANLkTi=0Pxg09x8DdVDVy9Ur7r1dgB+4LM3q0hM4_8Rg@mail.gmail.com>
	<1298419839.17118.5.camel@m0nster>
X-Hashcash: 1:20:110223:bryanh@codeaurora.org::GjL9j5l+ftNvd7pv:00000000000000000000000000000000000000000U6X
X-Hashcash: 1:20:110223:linux-kernel@vger.kernel.org::IsNyYDKsbnA8k44x:0000000000000000000000000000000000Mpp
X-Hashcash: 1:20:110223:dwalker@fifo99.com::5R3xyuBetGCfELUI:00000000000000000000000000000000000000000001uGZ
X-Hashcash: 1:20:110223:linux-arm-msm@vger.kernel.org::c5bzLySCF7H2KQoT:000000000000000000000000000000002Oa2
X-Hashcash: 1:20:110223:pavel@ucw.cz::9n63iSzeyh1dyQFx:000002YkR
X-Hashcash: 1:20:110223:kheitke@codeaurora.org::yk4uPOki7QNKJUpj:0000000000000000000000000000000000000002m6D
X-Hashcash: 1:20:110223:linux-arm-kernel@lists.infradead.org::s7VKYgunicaVQjrE:00000000000000000000000002UAe
X-Hashcash: 1:20:110223:dima@android.com::IadTU3Se5xbwrU8r:0437L
X-Hashcash: 1:20:110223:tsoni@codeaurora.org::Dm6+fz0dbfwIrH2F:00000000000000000000000000000000000000000BC7g
Date: Tue, 22 Feb 2011 16:17:20 -0800
In-Reply-To: <1298419839.17118.5.camel@m0nster> (Daniel Walker's message of
	"Tue, 22 Feb 2011 16:10:39 -0800")
Message-ID: <8ya62sbli3z.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22 2011, Daniel Walker wrote:

> On Tue, 2011-02-22 at 12:47 -0800, Dima Zavin wrote:
>
>> What is the problem leaving it under arch/arm/mach-msm?
>
> Because it's a driver.

There are a lot of other drivers currently under various arch
subsystems.  I'm not sure if a driver that is specific to only one arch
has a strong reason to be elsewhere in the kernel.  If there was a
possibility of there being other devices that used SSBI, it might make
sense to put it elsewhere.  But, as far as I know, this device is only
found on MSM chips.

It seems kind of unusual to create an entirely new directory under
drivers to hold what will only ever be a single driver.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
