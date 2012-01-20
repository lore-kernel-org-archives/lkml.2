Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab2ATVza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 16:55:30 -0500
Received: from smtp.tele.fi ([192.89.123.25]:42067 "EHLO
	vulpes-int.media.sonera.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755390Ab2ATVz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 16:55:29 -0500
X-Greylist: delayed 2758 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jan 2012 16:55:29 EST
X-Originating-Ip: [194.89.68.22]
Date: Fri, 20 Jan 2012 23:09:29 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: radeon issues on MacBook Pro 8,2
Message-ID: <20120120210929.GX12984@reaktio.net>
References: <20120119171808.GB23144@ubuntu-macmini> <CADnq5_MiLE0XSpbrd66003DVxdR9c4MgQav3BD+bWtrKvbf+7Q@mail.gmail.com> <20120119205317.GC23144@ubuntu-macmini>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120119205317.GC23144@ubuntu-macmini>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 02:53:17PM -0600, Seth Forshee wrote:
> On Thu, Jan 19, 2012 at 02:48:52PM -0500, Alex Deucher wrote:
> > On Thu, Jan 19, 2012 at 12:18 PM, Seth Forshee
> > <seth.forshee@canonical.com> wrote:
> > > I'm seeing several issues related to the radeon driver on a MacBook Pro
> > > 8,2 with the following graphics card:
> > >
> > >  ATI Technologies Inc Whistler [AMD Radeon HD 6600M Series] [1002:6741]
> > >
> > > All problems were observed when using kernel version 3.2.1. None are
> > > seen when using fglrx.
> > >
> > >  1. Excessive power draw. When using the radeon driver ACPI reports a
> > >    power draw of about 30W on an idle desktop. Using fglrx brings this
> > >    number down to 15W.
> > 
> > The power saving features of the open source driver are not yet as
> > good as the closed source driver.  Please see the power management
> > section of this page (http://wiki.x.org/wiki/RadeonFeature) for more
> > info on the options currently available.
> 
> The dynpm option makes a small difference, saving about 2W. I did notice
> an ocassional flash on the screen with this option, and the same flash
> each time I changed the power options.
> 

Btw how do you measure the power draw? 


> The only thing that improves things significatnly is the "low" profile
> method, which gets it down to about 18.5W.
> 

I have older radeon (Mobility HD3650) and only the "low" profile makes it usable.. 
the "default" profile will overheat the laptop and crash it, or then Linux does 
automatic emergency thermal shutdown to protect the laptop.

If I boot some Linux livecd the laptop will basicly overheat and shutdown by itself
before the desktop is loaded from the livecd.. :( 

-- Pasi

