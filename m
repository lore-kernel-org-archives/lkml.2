Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab0JSLw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:52:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51187 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab0JSLwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:52:54 -0400
Date: Tue, 19 Oct 2010 14:52:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Balbi, Felipe" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
Message-ID: <20101019115236.GL31170@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
 <1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
 <20101019103234.GI31170@legolas.emea.dhcp.ti.com>
 <AANLkTinXzMQXoyyu+anSCvSuE9w3FWAP5HswDS0kfpzE@mail.gmail.com>
 <20101019111613.GJ31170@legolas.emea.dhcp.ti.com>
 <AANLkTikkMphKa2DGGtWxy-3LpFX0kn92UEYPj==Euzok@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AANLkTikkMphKa2DGGtWxy-3LpFX0kn92UEYPj==Euzok@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 19, 2010 at 06:36:32AM -0500, Felipe Contreras wrote:
>That is actually the intention.

so it's a bit messed up one :-p

>It's the other way around. He wanted to get rid of defconfigs
>completely by moving the complexity to Kconfigs:

Yes, but he was suggesting to add things like Kconfig.rx51 and that
would be selecting correct drivers to get rx51 working, he was
definitely not suggesting to add sensible defaults all over the tree.

>http://article.gmane.org/gmane.linux.kernel/994720
>http://article.gmane.org/gmane.linux.kernel/994706
>http://article.gmane.org/gmane.linux.kernel/994718
>
>You seem to be pushing for the exact opposite; keep the complexity on
>the defconfigs and the burden on the user creating configs.

no, you got me wrong. We do need to get rid of defconfigs, but we have
to do so while keeping the resulting binary working and as of today, if
you enable more than one transceiver driver, it won't work.

>Ok. But for now 'default y if ARCH_OMAP3' for TWL4030_USB doesn't
>hurt, nor increases the total size of Kconfigs, and solves a real
>problem.

I don't see it that way. I see that there will be boards with one too
many transceivers enabled and the resulting binary won't work, but I'll
leave that for Greg to decide.

-- 
balbi
