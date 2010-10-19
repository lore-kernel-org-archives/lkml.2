Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0JSJCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:02:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42322 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab0JSJCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:02:09 -0400
Date: Tue, 19 Oct 2010 12:01:49 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Balbi, Felipe" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 3/3] drivers: cleanup Kconfig stuff
Message-ID: <20101019090149.GC31170@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1287475466-8927-1-git-send-email-felipe.contreras@gmail.com>
 <1287475466-8927-4-git-send-email-felipe.contreras@gmail.com>
 <20101019081855.GI12470@legolas.emea.dhcp.ti.com>
 <AANLkTi=8=M+egdo5o6nyMOaCyMCLaZdwJF3WKFwZnbd4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AANLkTi=8=M+egdo5o6nyMOaCyMCLaZdwJF3WKFwZnbd4@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 19, 2010 at 03:34:55AM -0500, Felipe Contreras wrote:
>> It was fine as it was before. NAK
>
>It's not fine. You can build with CONFIG_USB_G_NOKIA=y, and it doesn't
>work. Definitely some dependency is missing.

if phonet is not set it should not build. If phonet is set to module and
g_nokia to built-in, then it's your mistake.

>How do you handle USB_MUSB_HDRC=y and NOP_USB_XCEIV=n and TWL4030_USB=n?
>
>depends on (NOP_USB_XCEIV || TWL4030_USB) ?

you're selecting, not depending on this patch. What I mean is that you
will enable a useless driver on some boards if you "select TWL4030_USB
if ARCH_OMAP3"

-- 
balbi
