Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab2IHUWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 16:22:47 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43808 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab2IHUWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 16:22:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Question about failure in PCI power-state change
Date: Sat, 8 Sep 2012 22:29:01 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        =?utf-8?q?=E6=9D=8E=E6=9C=9D=E6=98=8E?= 
	<chaoming_li@realsil.com.cn>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>
References: <504A78E9.4030005@lwfinger.net> <CAErSpo7GEkN1XLZ=UeXmDZrLnp_648mH-sLYa9hMgOqz7t+b7Q@mail.gmail.com>
In-Reply-To: <CAErSpo7GEkN1XLZ=UeXmDZrLnp_648mH-sLYa9hMgOqz7t+b7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209082229.01465.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 08, 2012, Bjorn Helgaas wrote:
> +cc Rafael, Huang, linux-pm
> 
> On Fri, Sep 7, 2012 at 3:44 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> > Hi,
> >
> > On occasion when I unload and reload driver rtl8192ce, I get the message
> >
> > "Refused to change power state, currently in D3"
> >
> > I added additional info to the printk and discovered that it was trying to
> > change to state D0. The problem seems to occur when I have made a
> > connection, unloaded the driver, and reloaded it. If I do not make a
> > connection before unloading, then the problem is a lot less likely.
> >
> > This is with kernel 3.6-rc4 from wireless-testing. A Google search shows
> > that the problem is usually due to suspend/resume difficulties, but this
> > machine has not been suspended.
> >
> > I would appreciate any help that you might give in solving this issue.

I think writing "on" to the /sys/devices/.../power/control attribute of the device
in question would help.

Thanks,
Rafael
