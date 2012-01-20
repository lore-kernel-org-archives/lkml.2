Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2ATX0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 18:26:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34099 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2ATX0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 18:26:50 -0500
Date: Fri, 20 Jan 2012 17:26:44 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Pasi =?utf-8?B?S8Okcmtrw6RpbmVu?= <pasik@iki.fi>
Cc: Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Colin King <colin.king@canonical.com>
Subject: Re: radeon issues on MacBook Pro 8,2
Message-ID: <20120120232644.GB2292@ubuntu-macmini>
Mail-Followup-To: Pasi =?utf-8?B?S8Okcmtrw6RpbmVu?= <pasik@iki.fi>,
	Alex Deucher <alexdeucher@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Colin King <colin.king@canonical.com>
References: <20120119171808.GB23144@ubuntu-macmini>
 <CADnq5_MiLE0XSpbrd66003DVxdR9c4MgQav3BD+bWtrKvbf+7Q@mail.gmail.com>
 <20120119205317.GC23144@ubuntu-macmini>
 <20120120210929.GX12984@reaktio.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120120210929.GX12984@reaktio.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 11:09:29PM +0200, Pasi Kärkkäinen wrote:
> On Thu, Jan 19, 2012 at 02:53:17PM -0600, Seth Forshee wrote:
> > On Thu, Jan 19, 2012 at 02:48:52PM -0500, Alex Deucher wrote:
> > > On Thu, Jan 19, 2012 at 12:18 PM, Seth Forshee
> > > <seth.forshee@canonical.com> wrote:
> > > > I'm seeing several issues related to the radeon driver on a MacBook Pro
> > > > 8,2 with the following graphics card:
> > > >
> > > >  ATI Technologies Inc Whistler [AMD Radeon HD 6600M Series] [1002:6741]
> > > >
> > > > All problems were observed when using kernel version 3.2.1. None are
> > > > seen when using fglrx.
> > > >
> > > >  1. Excessive power draw. When using the radeon driver ACPI reports a
> > > >    power draw of about 30W on an idle desktop. Using fglrx brings this
> > > >    number down to 15W.
> > > 
> > > The power saving features of the open source driver are not yet as
> > > good as the closed source driver.  Please see the power management
> > > section of this page (http://wiki.x.org/wiki/RadeonFeature) for more
> > > info on the options currently available.
> > 
> > The dynpm option makes a small difference, saving about 2W. I did notice
> > an ocassional flash on the screen with this option, and the same flash
> > each time I changed the power options.
> > 
> 
> Btw how do you measure the power draw? 

You can get the instantaneous rate from the data under
/proc/acpi/battery, but I use a tool called powerstat [1], written by my
colleague Colin King. The advantage of powerstat is that it samples the
ACPI data over a period of time and reports the average and standard
deviation. That way I have a better idea of how much power is really
being drawn and the quality of the value reported.

[1] http://kernel.ubuntu.com/git?p=cking/powerstat.git
