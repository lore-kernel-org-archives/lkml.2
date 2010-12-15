Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab0LORmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:42:18 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24730 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab0LORmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:42:15 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6198"; a="66741910"
Message-ID: <4D08FDF6.3040403@codeaurora.org>
Date: Wed, 15 Dec 2010 09:42:14 -0800
From: Steve Muckle <smuckle@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20101019 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: David Brown <davidb@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH v5 5/5] msm: add SMP support for msm
References: <1292302233-16194-1-git-send-email-johlstei@codeaurora.org> <1292302233-16194-6-git-send-email-johlstei@codeaurora.org> <AANLkTimnuTcv+5cWNzvV-Z=1LHsAmTojDSBJMjjOs7K+@mail.gmail.com> <20101215134414.GA8682@huya.qualcomm.com> <20101215160323.GA9937@n2100.arm.linux.org.uk>
In-Reply-To: <20101215160323.GA9937@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On 12/15/10 08:03, Russell King - ARM Linux wrote:
> As far as hotplug code goes, I wish folk would see what their hardware
> can actually do with the secondary CPUs - can they take the CPU fully
> offline and into a proper dormant state, and when they reawaken it, can
> they wake it in the same manner as the CPU is brought online during
> boot.

This is possible with MSM8660 and we have this working internally, but
it relies on a fair amount of power management code that is not ready to
be sent out yet. This hotplug support is just meant as a starting point
while getting the core MSM8660 support in.

thanks,
Steve

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
