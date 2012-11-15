Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768001Ab2KOOKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:10:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767903Ab2KOOKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:10:07 -0500
Date: Thu, 15 Nov 2012 15:10:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 3.7-rc3: mouses stopped working
In-Reply-To: <20121115140736.GA2651@elf.ucw.cz>
Message-ID: <alpine.LNX.2.00.1211151508350.15877@pobox.suse.cz>
References: <20121115132849.GA4062@elf.ucw.cz> <alpine.LNX.2.00.1211151429240.15877@pobox.suse.cz> <20121115140736.GA2651@elf.ucw.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012, Pavel Machek wrote:

> > > I'm using thinkpad x60 with external USB mouse. On first boot, both
> > > mice stopped working after minute-or-so in X. Lets see if it breaks on
> > > the next boot, too..
> > > 
> > > USB keyboard still works, and dmesg seems to contain repeated
> > > detections of USB mouse. But unplugging USB mouse does not bring
> > > internal trackpoint to work, so...
> > > 
> > > Any ideas?
> > 
> > Does the dmesg also contain information regarding disconnection of the 
> > mouse before it stopped working?
> 
> See the other mail, /dev/input/mice is not working.
> 
> And yes, mouse seems to be detected multiple times; it may have
> happened before, with /dev/input/mice I would not notice.
> 
> dmesg attached.

If you have mouse that is buggy and periodically 
disconnecting/reconnecting itself, you need commit df0cfd6990347c, which 
went into 3.7-rc5 (it's a regression fix from -rc1).

-- 
Jiri Kosina
SUSE Labs
