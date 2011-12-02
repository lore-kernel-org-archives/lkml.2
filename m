Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab1LBNXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 08:23:31 -0500
Received: from smtp203.alice.it ([82.57.200.99]:42015 "EHLO smtp203.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab1LBNX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 08:23:29 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Dec 2011 08:23:29 EST
From: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH 1/3] ARM: msm: Remove MSM7x00 support
Date: Fri, 2 Dec 2011 14:17:17 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-12-generic; KDE/4.6.5; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1322699344-28422-1-git-send-email-davidb@codeaurora.org> <20111201201950.GE9581@n2100.arm.linux.org.uk> <20111201202632.GA25247@huya.qualcomm.com>
In-Reply-To: <20111201202632.GA25247@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112021417.17082.GNUtoo@no-log.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>And I've learned what I needed to now: someone does still care about
>the target.
However in a response to the following mail:
[Question] RPC and SMD implementation
David Brown already told that:
>Is there much reason to get the msm72xx support into the kernel in the
>first place?  These targets are old, and I don't believe any new
>devices are being made using them
And:
>Things are a lot easier in the newer RPC/SMD versions,
>and I don't see a strong reason to keep the kruft in the kernel
>necessary to support the 72xx chips.
I guess that means that RPC for msm7x00 won't hit mainline.
So without RPC the port to mainline cannot be complete(no modem, no audio, no 
GPS,and maybe more depending on the device).

Denis.
