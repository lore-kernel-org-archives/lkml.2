Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab1LBP0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 10:26:15 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16839 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab1LBP0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 10:26:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6547"; a="143085192"
Date: Fri, 2 Dec 2011 07:26:09 -0800
From: David Brown <davidb@codeaurora.org>
To: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
Cc: David Brown <davidb@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: msm: Remove MSM7x00 support
Message-ID: <20111202152609.GA6986@huya.qualcomm.com>
References: <1322699344-28422-1-git-send-email-davidb@codeaurora.org>
 <20111201201950.GE9581@n2100.arm.linux.org.uk>
 <20111201202632.GA25247@huya.qualcomm.com>
 <201112021417.17082.GNUtoo@no-log.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112021417.17082.GNUtoo@no-log.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 02:17:17PM +0100, Denis 'GNUtoo' Carikli wrote:
> >And I've learned what I needed to now: someone does still care about
> >the target.
> However in a response to the following mail:
> [Question] RPC and SMD implementation
> David Brown already told that:
> >Is there much reason to get the msm72xx support into the kernel in the
> >first place?  These targets are old, and I don't believe any new
> >devices are being made using them
> And:
> >Things are a lot easier in the newer RPC/SMD versions,
> >and I don't see a strong reason to keep the kruft in the kernel
> >necessary to support the 72xx chips.
> I guess that means that RPC for msm7x00 won't hit mainline.
> So without RPC the port to mainline cannot be complete(no modem, no audio, no 
> GPS,and maybe more depending on the device).

There isn't anything stopping someone from working on the port.  The
Android kernels for the target are still available.  But, I think most
people working on the MSM code will be focusing on newer devices,
especially now that there is an 8660 dev board available.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
