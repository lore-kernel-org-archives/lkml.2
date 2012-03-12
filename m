Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2CLPkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:40:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38219 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab2CLPkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:40:07 -0400
Date: Mon, 12 Mar 2012 10:40:00 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] platform/x86: Add driver for Apple gmux device
Message-ID: <20120312154000.GC12322@ubuntu-macmini>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1329424465-1211-1-git-send-email-seth.forshee@canonical.com>
 <1329921457-26887-1-git-send-email-seth.forshee@canonical.com>
 <20120312142126.GA11969@srcf.ucam.org>
 <20120312145701.GA12322@ubuntu-macmini>
 <20120312150717.GA13211@srcf.ucam.org>
 <20120312151852.GB12322@ubuntu-macmini>
 <20120312152224.GA13916@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312152224.GA13916@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 03:22:24PM +0000, Matthew Garrett wrote:
> On Mon, Mar 12, 2012 at 10:18:52AM -0500, Seth Forshee wrote:
> 
> > Why do you presume it works under Windows? Boot camp installs a pile of
> > drivers for Windows, one of those could be a driver for the backlight. I
> > don't know either way. But it's pretty clear that MacOS is using the
> > gmux for the backlight when it is present from the reverse engineering
> > work done by others.
> 
> The only reason to provide it at all is for Windows - it's never going 
> to be used under OS X.

I'm not so sure. The MacBook Pro 8,1 and 8,2 seem to use the same BIOS
implementation -- the version numbers and DSDTs are identical.  The 8,1
has only Intel graphics, no gmux, and a working acpi_video0 backlight
under Linux. The 8,2 has hybrid ATI/Intel, a gmux w/ working backlight
control, and acpi_video0 does not work.

So while I'm not sure, I can't rule out that the acpi_video backlight
might be provided specifically for the 8,1 and that OS X is using it.
Unfortunately I don't have an 8,1 that I can play with to try and work
it out.

Seth

