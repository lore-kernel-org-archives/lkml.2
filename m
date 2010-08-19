Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab0HSN2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 09:28:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:43876 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab0HSN2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 09:28:46 -0400
Subject: Re: [PATCH 0/8] [Resend] ideapad: using EC command to control
 rf/camera power
From: David Woodhouse <dwmw2@infradead.org>
To: Ike Panhc <ike.pan@canonical.com>
Cc: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Brown, Len" <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
In-Reply-To: <4C6CA31D.6030407@canonical.com>
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
	 <1282127719.2747.211.camel@localhost>
	 <20100818155128.GA24363@darkside.kls.lan>  <4C6CA31D.6030407@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 14:28:36 +0100
Message-ID: <1282224517.1730.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 11:21 +0800, Ike Panhc wrote:
> 
> > 2nd: both Bluetooth killswitches reproducibly disappear when I block
> > ideapad_bluetooth either via Gnome bluetooth-applet or via rfkill block
> > 1 and subsequently reboot. After the reboot rfkill list shows:
> > 
> > 0: ideapad_wlan: Wireless LAN
> >         Soft blocked: no
> >         Hard blocked: no
> > 1: ideapad_killsw: Wireless LAN
> >         Soft blocked: no
> >         Hard blocked: no
> > 2: phy0: Wireless LAN
> >         Soft blocked: no
> >         Hard blocked: no
> > 
> > Powering the machine off and on again restores both killswitches.
> > Interesting is: this does not happen when I boot into single-user mode,
> > rfkill block 1 there and reboot. In this case, both killswitches are
> > back.
> This is interesting. looks like the cfgbit will change on S12 if BIOS
> remember it has to shutdown when booting. I will try if the same problem
> happen on my ideapads. 

If we can solve this, I'm inclined to suggest that we submit your code
to Linus to replace mine in 2.6.36. We needed *something* as a stopgap
to solve the rfkill issues, but this is better than what we have in
2-6.36-rc1.

-- 
dwmw2

