Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1BYDUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 22:20:48 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31277 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab1BYDUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 22:20:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6267"; a="76567141"
X-Hashcash: 1:20:110225:gregkh@suse.de::3DA56qPmqx1BoYo2:0003Lfs
From: David Brown <davidb@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Dima Zavin <dima@android.com>, Greg Kroah-Hartman <gregkh@suse.de>,
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
X-Hashcash: 1:20:110225:linux-arm-msm@vger.kernel.org::Y5vQEQVfVVJtDHeZ:0000000000000000000000000000000005zm
X-Hashcash: 1:20:110225:dima@android.com::B+t5YT+NPS8CnbBZ:00ZX9
X-Hashcash: 1:20:110225:kheitke@codeaurora.org::i1tD4YdGJ5b3zT7c:0000000000000000000000000000000000000003tpA
X-Hashcash: 1:20:110225:swetland@google.com::QuyB6FAoiA1tbxhH:00000000000000000000000000000000000000000080Ye
X-Hashcash: 1:20:110225:linux-kernel@vger.kernel.org::GaJOY3IE74cdkIBE:0000000000000000000000000000000005zL1
X-Hashcash: 1:20:110225:linux-arm-kernel@lists.infradead.org::8+HyL71DAfciJSOU:00000000000000000000000008hfB
X-Hashcash: 1:20:110225:dwalker@fifo99.com::FAfJe/FzwuduNzT/:00000000000000000000000000000000000000000006qKt
X-Hashcash: 1:20:110225:tsoni@codeaurora.org::C0IHUaNozvPvg8tN:00000000000000000000000000000000000000000AtpU
Date: Thu, 24 Feb 2011 19:20:45 -0800
In-Reply-To: <AANLkTikD1Ued=rit1QbMWwe3NGFz2iQ-KO7B=-N6Ok-2@mail.gmail.com>
	(Dima Zavin's message of "Thu, 24 Feb 2011 18:39:48 -0800")
Message-ID: <8ya8vx4dcky.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24 2011, Dima Zavin wrote:

> On that note, should we have a "drivers/arm/msm" instead of just
> "drivers/msm"? Other non-msm arm sub-arches probably have the same
> problem and polluting drivers/ top-level for every arm-subarch maybe
> undesirable.

I'm moving linux-kernel to the 'to' field, and adding Greg KH to CC.

This is about a new driver (ssbi) for the MSM chips, and where the
driver for this should go.  The driver is specific to MSM chips (as far
as I know, the bus is only supported there).  There are likely to be
future msm-specific drivers, so the suggestion was to put this under
drivers/msm, or possibly drivers/arm/msm.

Anyone other suggestions, or preferences for the location?

Thanks,
David Brown
