Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536Ab1J2RFL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 13:05:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932930Ab1J2RFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 13:05:10 -0400
Date: Sat, 29 Oct 2011 19:05:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: RE: [PATCH 1/1] Staging: hv: Move the mouse driver out of staging
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481AA53219@TK5EX14MBXC122.redmond.corp.microsoft.com>
Message-ID: <alpine.LNX.2.00.1110291904190.3541@pobox.suse.cz>
References: <1319645321-9770-1-git-send-email-kys@microsoft.com> <alpine.LNX.2.00.1110282026360.3541@pobox.suse.cz> <6E21E5352C11B742B20C142EB499E0481AA531D4@TK5EX14MBXC122.redmond.corp.microsoft.com> <20111028200315.GA30918@suse.de>
 <6E21E5352C11B742B20C142EB499E0481AA53219@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Oct 2011, KY Srinivasan wrote:

> > > > >  obj-$(CONFIG_HID_WACOM)		+= hid-wacom.o
> > > > >  obj-$(CONFIG_HID_WALTOP)	+= hid-waltop.o
> > > > >  obj-$(CONFIG_HID_WIIMOTE)	+= hid-wiimote.o
> > > > > +obj-$(CONFIG_HYPERV_MOUSE)	+= hv_mouse.o
> > > >
> > > > I'd prefer a bit to follow the current naming of the drivers in
> > > > drivers/hid directory ... all the device-specific (vendor-specific)
> > > > drivers currently are called hid-<vendor> or similar.
> > > >
> > > > We could talk about changing this naming scheme, but before we reach any
> > > > conclusion on this, I'd prefer this to stay for all drivers if possible.
> > >
> > > Do you want the driver module to conform to the naming scheme you have?
> > > Greg, in the past has resisted changing driver names, but I have no objection
> > > to conforming to the naming convention you have.
> > 
> > I recommend following the proper naming scheme.  As this driver is
> > auto-loaded when the virtual hardware is seen, the name really doesn't
> > matter at all.
> > 
> > So, how about 'hid-hyperv' or 'hid-hv'?
> 
> I will go with hid-hv  if there are no objections.

OK by me, thanks.

-- 
Jiri Kosina
SUSE Labs
