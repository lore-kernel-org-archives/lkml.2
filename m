Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab1EZQPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:15:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9818 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab1EZQPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:15:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6357"; a="93872155"
Message-ID: <744ad016b77694e43f07d8bbc8f5b439.squirrel@www.codeaurora.org>
In-Reply-To: <Pine.LNX.4.44L0.1105261028040.1960-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1105261028040.1960-100000@iolanthe.rowland.org>
Date: Thu, 26 May 2011 09:15:10 -0700 (PDT)
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
From: "Brokhman Tatyana" <tlinder@codeaurora.org>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Tanya Brokhman" <tlinder@codeaurora.org>, balbi@ti.com,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, "'open list'" <linux-kernel@vger.kernel.org>
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


Hi Alan,

>> I also thought of that. This can be done...
>> Just to make sure we're on the same page:
>> We can add a "max_sup_speed" field to struct usb_composite_driver. Each
>> of
>> the Gadget drivers will set this field prior to calling
>> usb_composite_probe(). Then, in usb_composite_probe(), we'll update the
>> composite_driver.speed as follows:
>>
>> 	composite_driver.speed = min(composite_driver.speed,
>> driver->max_sup_speed);
>
> Just call it max_speed.  You can mention in the kerneldoc that it is
> the maximum speed supported by the driver.

No problem. I understand that you agree to this approach?
I was going to wait for Felipe to comment but he'll be out of reach for
several days so I'll post a new patch set on Sunday.

Thanks for you help!

Tanya Brokhman
-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


