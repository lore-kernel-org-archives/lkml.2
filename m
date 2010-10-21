Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab0JUPls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:41:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47119 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758675Ab0JUPlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:41:44 -0400
Date: Thu, 21 Oct 2010 18:41:25 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <roger.quadros@nokia.com>
Cc: ext Felipe Contreras <felipe.contreras@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        "Balbi, Felipe" <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
Message-ID: <20101021154125.GR3958@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
 <4CBD9FD5.506@nokia.com>
 <AANLkTinRRyrXzqEu=u+CCYkmSNGm03SSo1tVG=5_wdpo@mail.gmail.com>
 <4CBE9E69.6060803@nokia.com>
 <AANLkTinOYDBMVZ3ibG3Md7jdOuOC6NkGWaugvHwT6uqF@mail.gmail.com>
 <4CBEB312.7060400@nokia.com>
 <AANLkTikom=eRFqCJmYE+k1zn5K2MR9s8HhNXtjOvUqvr@mail.gmail.com>
 <4CBEE186.8090701@nokia.com>
 <AANLkTinULxyUg_vHjk9RsQm4Row7vRC9ApzYXt7ZMQJD@mail.gmail.com>
 <4CC0493F.1000701@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4CC0493F.1000701@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 21, 2010 at 09:07:59AM -0500, Roger Quadros wrote:
>But I'm not sure that omap_udc is used only for OMAP1 architecture.
>Dave/Tony should confirm this.

Maybe the old omap2420_h4 board still uses it, but from 2430 I think the
ip isn't even there anymore.

-- 
balbi
