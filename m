Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab2KSUWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 15:22:43 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:53577 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab2KSUWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 15:22:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000/493] remove CONFIG_HOTPLUG as an option
Date: Mon, 19 Nov 2012 21:27:09 +0100
Message-ID: <2170877.01mKLSMGf6@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121119200149.GA31589@kroah.com>
References: <1353112043-11800-1-git-send-email-wfp5p@virginia.edu> <20121119195555.GA21922@core.coreip.homeip.net> <20121119200149.GA31589@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 19, 2012 12:01:49 PM Greg KH wrote:
> On Mon, Nov 19, 2012 at 11:55:56AM -0800, Dmitry Torokhov wrote:
> > On Fri, Nov 16, 2012 at 07:19:10PM -0500, Bill Pemberton wrote:
> > > CONFIG_HOTPLUG is no longer an optional setting.  In order to remove
> > > it as on option code paths that check CONFIG_HOTPLUG will removed
> > > along with the attributes __devexit_p, __devexit, __devinitconst, and
> > > __devinitdata.
> > > 
> > > I'll save the list from the mailbomb of this huge patchset.  The
> > > patches themselves are going to Greg KH for the driver core tree.
> > > 
> > 
> > _iff_ we are going to do this I'd prefer pushing input pieces through my
> > tree to limit clashes with other work.
> 
> That's fine with me.  I'll ignore any drivers/input/ patches then, is
> that ok?

Please do the same for PM/ACPI.

Do I need to pull anything for those patches to compile without problems?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
