Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab1EaT3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:29:54 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46343 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1EaT3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:29:52 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6362"; a="94678126"
Message-ID: <6330092a26bc057e48560971214001ac.squirrel@www.codeaurora.org>
In-Reply-To: <Pine.LNX.4.44L0.1105311453350.1830-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1105311453350.1830-100000@iolanthe.rowland.org>
Date: Tue, 31 May 2011 12:29:19 -0700 (PDT)
Subject: Re: [PATCH v14 9/9] usb: Adding SuperSpeed support to dummy_hcd
From: "Brokhman Tatyana" <tlinder@codeaurora.org>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Brokhman Tatyana" <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, "open list" <linux-kernel@vger.kernel.org>
Reply-To: tlinder@codeaurora.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> Let's put it another way.  If the "is_super_speed" module parameter is
> set to False then we know that the emulated connection will never run
> at SS.  Therefore there's no point in registering a SS root hub.
>

Ok, I'm convinsed. :) Will update.

Thanks
Tanya Brokhman
-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


