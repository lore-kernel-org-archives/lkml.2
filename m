Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1F3Slt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 14:41:49 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25761 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab1F3Slr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:41:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6393"; a="100953515"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org> <1308231068-24038-6-git-send-email-tlinder@codeaurora.org> <20110630174538.GA7979@xanatos>
In-Reply-To: <20110630174538.GA7979@xanatos>
Subject: RE: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to devio.c
Date: Thu, 30 Jun 2011 21:41:40 +0300
Message-ID: <063601cc3755$5cfe0180$16fa0480$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acw3TYf2B2HIOGmITsq5hOgD8hpD/QABxAww
Content-Language: he
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah,

> Will this patch be used to create a userspace UAS driver, or are you
> envisioning other ways userspace might use streams?  I ask because I
> can't think of another usage of streams in currently available devices.
> 

No, this patch isn't used for UAS driver. It's used by us only for several
tests that we implemented in the user space unittests framework we released
with this patch. We used this FW to test our superspeed support
implementation and the UAS gadget driver. It's a userspace application that
uses Google test and libusb.
That's the only reason we need this patch at the moment.
But in any case, due to the comments we got on it from Greg/Alan/Felipe this
patch is rewritten at the moment by its original author Amit Blay
(ablay@codeaurora.org). He'll post a new version of it once he's done.


Thanks,
Tanya Brokhman
---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.




