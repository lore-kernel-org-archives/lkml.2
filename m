Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1FMSIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:08:05 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61759 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab1FMSIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:08:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6376"; a="97392865"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: <balbi@ti.com>, <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'open list:FREESCALE USB PER...'" <linuxppc-dev@lists.ozlabs.org>,
        "'open list:OMAP USB SUPPORT'" <linux-omap@vger.kernel.org>
References: <03b901cc29c0$6538e970$2faabc50$@org> <Pine.LNX.4.44L0.1106131036430.1983-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106131036430.1983-100000@iolanthe.rowland.org>
Subject: RE: [PATCH] usb:gadget: use min_t() macro instead of min()
Date: Mon, 13 Jun 2011 21:07:52 +0300
Message-ID: <03db01cc29f4$d472bcb0$7d583610$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
thread-index: Acwp16DWufwIl5G7RaimRzoAT5Gk/wAA+1FQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The change I suggested involved replacing two typecasts with a single
> min_t.  All (or almost all) the places this patch touches currently
> contain only one typecast, so the motivation for changing them is a lot
> weaker.
> 
You're right. So what's the final call on this one? Do you think it can be
merged or you prefer not change anything? I personally think the code looks
nicer using min_t instead of min with casting but that's just my opinion and
of course there are arguments against this patch.


Thanks,
Tanya Brokhman
---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.





