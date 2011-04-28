Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1D1FQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 01:16:46 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23451 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab1D1FQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 01:16:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6329"; a="88262760"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Felipe Balbi'" <balbi@ti.com>, <gregkh@suse.de>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <20110414114605.GA17871@linutronix.de> <Pine.LNX.4.44L0.1104141141480.2487-100000@iolanthe.rowland.org> <003501cc03d9$d3989300$7ac9b900$@org> <4DB69D6B.9060106@linutronix.de>
In-Reply-To: <4DB69D6B.9060106@linutronix.de>
Subject: RE: [PATCH] usb: merge the two dummy_hcds into one
Date: Thu, 28 Apr 2011 08:18:02 +0300
Message-ID: <002601cc0563$a81dfae0$f859f0a0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwD/CL0+zFighL+Q/OzaOU1AccTiQBZ2pig
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Please take a look at xhci_pci_probe() where usb_create_shared_hcd() is
> used. It was introduced by
> 
> commit f6ff0ac878eb420011fa2448851dd48c3a7e7b31
> Author: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Date:   Thu Dec 16 11:21:10 2010 -0800
> 
>      xhci: Register second xHCI roothub.
> 
> in v2.6.39-rc1.
> 
> Sebastian

Thanks Sebastian. I'm on it.

Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




