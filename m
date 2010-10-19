Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933964Ab0JSKcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:32:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42693 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933717Ab0JSKcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:32:52 -0400
Date: Tue, 19 Oct 2010 13:32:34 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        "Balbi, Felipe" <balbi@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
Message-ID: <20101019103234.GI31170@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
 <1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 19, 2010 at 05:03:28AM -0500, Felipe Contreras wrote:
>+	depends on (NOP_USB_XCEIV || TWL4030_USB)
>+	default y if ARCH_OMAP3
>+	default y if ARCH_DAVINCI || MACH_OMAP3EVM || BLACKFIN

it could be only me, but I see these kind of dependencies tend to
disaster. They can all grow to infinity. Soon, we will have another twl
family of devices, or we will have another MACH_* which will need
nop_xceiv, etc etc.

-- 
balbi
