Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1DPRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 13:09:26 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46085 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1DPRJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 13:09:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6317"; a="86007758"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Greg KH'" <greg@kroah.com>
Cc: <gregkh@suse.de>, <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        <balbi@ti.com>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1302788176-27972-1-git-send-email-tlinder@codeaurora.org> <20110414174007.GA11640@kroah.com>
In-Reply-To: <20110414174007.GA11640@kroah.com>
Subject: RE: [RFC/PATCH v3 2/5] uas: MS UAS Gadget driver - Infrastructure
Date: Sat, 16 Apr 2011 20:10:23 +0300
Message-ID: <003501cbfc59$2eab53a0$8c01fae0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acv6yyI+4gk1JPMVQzOMQp5Su+vLZwBja/Gg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > A new module parameter was added to the mass_storage module:
> > bool use_uasp. (default = 0)
> > If this parameter is set to true, the mass_storage module will
> register
> > with the UAS configuration as the devices first configuration and
> > operate according to the UAS protocol.
> 
> Ick, I'd _really_ prefer no new kernel module parameters.  It gets
> messy
> and a pain to support and document (see you didn't document it...)
> 
> Any way to do this "automatically"?  Or some other way?
> 
> thanks,

We've added this parameter as a first development phase to help us in
debugging/testing. The gadget driver is functional and feature complete at
the moment but we're still working on some improvements and further testing.
The module parameter will be removed in the final version.


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




