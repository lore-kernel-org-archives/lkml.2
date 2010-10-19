Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0JSPeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:34:24 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:60748 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab0JSPeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:34:22 -0400
X-Greylist: delayed 1722 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2010 11:34:22 EDT
MIME-Version: 1.0
Date: Tue, 19 Oct 2010 10:05:33 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
In-Reply-To: <AANLkTim3NsgjC3Nh8VCCrx4cV1Y+kn38=30=en0KCft6@mail.gmail.com>
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com> <1287482608-11320-4-git-send-email-felipe.contreras@gmail.com> <20101019103234.GI31170@legolas.emea.dhcp.ti.com> <AANLkTinXzMQXoyyu+anSCvSuE9w3FWAP5HswDS0kfpzE@mail.gmail.com> <20101019111613.GJ31170@legolas.emea.dhcp.ti.com> <AANLkTikkMphKa2DGGtWxy-3LpFX0kn92UEYPj==Euzok@mail.gmail.com> <20101019115236.GL31170@legolas.emea.dhcp.ti.com> <AANLkTim3NsgjC3Nh8VCCrx4cV1Y+kn38=30=en0KCft6@mail.gmail.com>
Message-ID: <6ea089ac75d4d15d88698468eacb7fe3@secure211.sgcpanel.com>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(already at home so using personal email)

On Tue, 19 Oct 2010 17:32:07 +0300, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> There are two parts, one part is to fix the Kconfigs, and another was
> to come up with a way to replace the horrible defconfigs. Part two is
> mostly fixed thanks to 'make savedefconfig', since the defconfigs are
> not so horrible any more, but part one is a continued effort.
> 
> For part two Linus had the idea to use Kconfigs instead of defconfigs,
> but they would mostly look very similar to the current ones generated
> by 'make savedefconfig'.
> 
> I don't know what makes you think Linus didn't want part one to be
> done. He wanted the Kconfig.rx51 to be human readable, and you are
> proposing that TWL4030_USB should be manually added there... I don't
> think TWL4030_USB says anything to human beings.

I don't read anywhere Linus saying we should clutter drivers/*/Kconfig
with defaults. I think you're inverting things, it's much better
to select TWL4030_USB when you enable MACH_OMAP_RX51 then default y
if MACH_OMAP_RX51.

> Yes, but how do you get rid of the defconfig while also having a
> working USB_G_NOKIA? Somehow a transceiver should be automatically
> selected.

and you do that selection when the board is enabled otherwise the
drivers Kconfig will be cluttered with default Y if blabla.

But like I said before, it's Greg's ball. Personally, I think
you're taking the wrong approach.

-- 
balbi
