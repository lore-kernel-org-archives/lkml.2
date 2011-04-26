Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab1DZGRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:17:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52040 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab1DZGRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:17:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6327"; a="87625972"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>
Cc: "'Felipe Balbi'" <balbi@ti.com>, <gregkh@suse.de>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <20110414114605.GA17871@linutronix.de> <Pine.LNX.4.44L0.1104141141480.2487-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1104141141480.2487-100000@iolanthe.rowland.org>
Subject: RE: [PATCH] usb: merge the two dummy_hcds into one
Date: Tue, 26 Apr 2011 09:18:53 +0300
Message-ID: <003501cc03d9$d3989300$7ac9b900$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acv6uvWCiprKJT+WTvyLWgUio0mBdgJHhTwg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 14 Apr 2011, Sebastian Andrzej Siewior wrote:
> 
> > This patch merges the two HCDs so there is one for both.
> 
> It is too premature for this.
> 
> In fact, the support for USB-3 HCDs is currently in flux.  Sarah Sharp
> has submitted a whole bunch of patches to allow for the creation of
> primary and secondary HCDs, representing the USB-2 and USB-3 root hubs
> of an xHCI controller.  dummy-hcd should use the same mechanism.
> 
> This will means creating only one host-side platform device, and then
> creating two usb_hcd structures below it.  Tanya's design should be
> based on Sarah's work.
> 

Hi Alan

Thank you for your inputs. I'm not familiar with Sarah's work you mentioned.
I'll have to look into that. Could you please point me to where I can find
this code? Has it been merged into linux-next yet or just posted on the
mailing list?


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




