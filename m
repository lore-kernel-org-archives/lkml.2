Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab1EXK3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 06:29:33 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40234 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1EXK3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 06:29:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6355"; a="93040174"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <BD27AEAC-1E6D-480C-9E18-A970B992AD75@ti.com> <Pine.LNX.4.44L0.1105231710590.2020-100000@iolanthe.rowland.org> <00ed01cc19d6$e1fef520$a5fcdf60$@org> <20110524101817.GB14371@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110524101817.GB14371@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Date: Tue, 24 May 2011 13:31:14 +0300
Message-ID: <010501cc19fd$b8738320$295a8960$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwZ++ByZ4wjVQLCS5GwK2IiMg3CQwAAQ6PA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe

> >
> > This version of dummy_hcd enumerates HS devices without any issues.
> 
> that's not what I saw, 

By "this version" I mean v12 and the one I just emailed, v13. Did you try
them out? I did and all worked just fine...

> but then again, maybe you changed driver->speed
> to super and didn't provide superspeed descriptors.
> 

Yes :) The driver->speed is updated in usb_composite_probe() if
CONFIG_USB_GADGET_SUPERSPEED is defined.

So, are we ok with this solution? The module parameter I mean?
Are you going to try the v13 in your branch? Please let me know how it goes
and of course if you have any comments.

Thanks!

Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum






