Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab0L1HXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 02:23:36 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28236 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0L1HXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 02:23:34 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6209"; a="68253652"
Message-ID: <aa7e809fb4e353906ded7e89ab7812b0.squirrel@www.codeaurora.org>
In-Reply-To: <37bcadfd86f17826a034a538b2ade8cd.squirrel@www.codeaurora.org>
References: <ccc3842ee0be7b1036143d1fccd005a0.squirrel@www.codeaurora.org>
    <20101221175827.GA8709@suse.de>
    <37bcadfd86f17826a034a538b2ade8cd.squirrel@www.codeaurora.org>
Date: Mon, 27 Dec 2010 23:23:19 -0800 (PST)
Subject: Re: [RFC/PATCH v2] usb: Add streams support to epautoconf.
From: merez@codeaurora.org
To: merez@codeaurora.org
Cc: "Greg KH" <gregkh@suse.de>, merez@codeaurora.org,
        "Greg KH" <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
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

>> On Wed, Dec 22, 2010 at 03:58AM, Maya Erez wrote:
> We beleive that the chip-specific code for net2280 and goku at the
> beginning of usb_ep_autoconfig can be moved to this new gadget op,
> therefore it is also needed for today's implementation. I will do the
> cahnge and send a new patch for review
Since the unique implementation of net2280 and goku don't cover all EPs
types and since we don't have the ability to fully test it, we didn't feel
confident to do the changes in their code. Therefore, we decided to remove
the new gadget_op.
Thanks,
Maya Erez
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum

