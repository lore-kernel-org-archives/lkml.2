Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab0LVL7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:59:14 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29196 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab0LVL7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:59:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6204"; a="67858673"
Message-ID: <37bcadfd86f17826a034a538b2ade8cd.squirrel@www.codeaurora.org>
In-Reply-To: <20101221175827.GA8709@suse.de>
References: <ccc3842ee0be7b1036143d1fccd005a0.squirrel@www.codeaurora.org>
    <20101221175827.GA8709@suse.de>
Date: Wed, 22 Dec 2010 03:58:58 -0800 (PST)
Subject: Re: [RFC/PATCH v2] usb: Add streams support to epautoconf.
From: merez@codeaurora.org
To: "Greg KH" <gregkh@suse.de>
Cc: merez@codeaurora.org, "Greg KH" <greg@kroah.com>,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Dec 21, 2010 at 09:58AM, Greg KH wrote:
> First rule of kernel development, "don't add infrastructure that you do
> not need today."
We beleive that the chip-specific code for net2280 and goku at the
beginning of usb_ep_autoconfig can be moved to this new gadget op,
therefore it is also needed for today's implementation. I will do the
cahnge and send a new patch for review
Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum


