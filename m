Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab2IHVuX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 17:50:23 -0400
Received: from netrider.rowland.org ([192.131.102.5]:51710 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753269Ab2IHVuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 17:50:19 -0400
Date: Sat, 8 Sep 2012 17:50:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?utf-8?q?=E6=9D=8E=E6=9C=9D=E6=98=8E?= 
	<chaoming_li@realsil.com.cn>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>
Subject: Re: Question about failure in PCI power-state change
In-Reply-To: <201209082229.01465.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1209081747030.4838-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Sep 2012, Rafael J. Wysocki wrote:

> On Saturday, September 08, 2012, Bjorn Helgaas wrote:
> > +cc Rafael, Huang, linux-pm
> > 
> > On Fri, Sep 7, 2012 at 3:44 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> > > Hi,
> > >
> > > On occasion when I unload and reload driver rtl8192ce, I get the message
> > >
> > > "Refused to change power state, currently in D3"
> > >
> > > I added additional info to the printk and discovered that it was trying to
> > > change to state D0. The problem seems to occur when I have made a
> > > connection, unloaded the driver, and reloaded it. If I do not make a
> > > connection before unloading, then the problem is a lot less likely.
> > >
> > > This is with kernel 3.6-rc4 from wireless-testing. A Google search shows
> > > that the problem is usually due to suspend/resume difficulties, but this
> > > machine has not been suspended.
> > >
> > > I would appreciate any help that you might give in solving this issue.
> 
> I think writing "on" to the /sys/devices/.../power/control attribute of the device
> in question would help.

Are you suggesting that this particular wireless adapter is unable to 
return to D0 from D3?

Larry, what happens if you try the suspend & resume your system while 
there's a connection?  Does a similar error occur during the resume?

Alan Stern

