Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1CGQ4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:56:25 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51767 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab1CGQ4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:56:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6277"; a="78274880"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Greg KH'" <gregkh@suse.de>
Cc: <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1299516532-28866-1-git-send-email-tlinder@codeaurora.org> <20110307165226.GA10934@suse.de>
In-Reply-To: <20110307165226.GA10934@suse.de>
Subject: RE: [RFC/PATCH 5/5] uas: HACK needed for UAS host.
Date: Mon, 7 Mar 2011 18:56:47 +0200
Message-ID: <000b01cbdce8$a74743e0$f5d5cba0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acvc6Ae0dBjXvuSdQBW94Kek8RaANwAACQ3w
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is not for submission, it's a HACK and the bug should be fixed in
another way. I've uploaded it because it's needed at the moment for working
with the UAS gadget driver and the current version of UAS host. I'm working
on resolving this issue with Sarah on another email thread. Just thought
that if someone wishes to use the driver right now this patch will be useful
to him.

Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum


> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Monday, March 07, 2011 6:52 PM
> To: Tatyana Brokhman
> Cc: linux-arm-msm@vger.kernel.org; ablay@codeaurora.org; open list:USB
> GADGET/PERIPH...; open list
> Subject: Re: [RFC/PATCH 5/5] uas: HACK needed for UAS host.
> 
> On Mon, Mar 07, 2011 at 06:48:51PM +0200, Tatyana Brokhman wrote:
> > REMOVE LATER ON!
> 
> Remove what?  The patch or this description?
> 
> confused,
> 
> greg k-h

