Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab1FMLwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 07:52:45 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33492 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab1FMLwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 07:52:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6375"; a="97303652"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'open list:FREESCALE USB PER...'" <linuxppc-dev@lists.ozlabs.org>,
        "'open list:OMAP USB SUPPORT'" <linux-omap@vger.kernel.org>
References: <1307877290-26672-1-git-send-email-tlinder@codeaurora.org> <20110613092438.GK3633@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110613092438.GK3633@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH] usb:gadget: use min_t() macro instead of min()
Date: Mon, 13 Jun 2011 14:52:34 +0300
Message-ID: <03b901cc29c0$6538e970$2faabc50$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
thread-index: Acwpq7zDcIN/UxAoS+2W8nU+iBOasgAE+UYQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Sun, Jun 12, 2011 at 02:14:46PM +0300, Tatyana Brokhman wrote:
> > Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> 
> I need a sensible commit log for this. Why do we need to change all
> min() to min_t() ?
> 

Actually, Alan asked me to make this change in one place in dummy_hcd. I
wasn't aware of the min_t macro before that. So when I searched the code for
other places I found quite a few and just thought that it would be "nicer"
to use min_t() instead of min() with casting. 
So we don't "need" to make this change. Everything works as is. This patch
only makes the code look nicer, nothing more.
I can elaborate the above in the commit log if you want.


Thanks,
Tanya Brokhman
---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.




