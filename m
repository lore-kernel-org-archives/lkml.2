Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1F2R1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 13:27:30 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46839 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1F2R11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 13:27:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6392"; a="100867848"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1309350899-23868-1-git-send-email-tlinder@codeaurora.org> <1309350899-23868-2-git-send-email-tlinder@codeaurora.org> <20110629123826.GQ2760@legolas.emea.dhcp.ti.com> <051801cc365a$73187140$594953c0$@org> <20110629124822.GS2760@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110629124822.GS2760@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v2 1/2] usb: gadget: add max_speed to usb_composite_driver
Date: Wed, 29 Jun 2011 20:27:17 +0300
Message-ID: <055801cc3681$d080ba00$71822e00$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acw2WtjZMpsx3XRXSvef+KIETelDNQAJjrqw
Content-Language: he
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> it might take a while for kernel.org to replicate things, maybe that's
> why you didn't see before ;-)
> 
> give it a few more minutes and check my gadget branch to see if it's
> all good, I'm going to test it again on beagleboard to be sure nothing
> is broken.
> 

Hi Felipe

I went over the emails and all is ok. Thanks!
One question: Greg/Alan mentioned that the compilation warning should be
fixed by __maybe_unused. I wasn't aware such thing existed. Just looked it
up. 
Do you want me to send you a patch that fixes that or have you done it
already and I missed it again :) ?


Thanks,
Tanya Brokhman
---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.





