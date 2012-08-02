Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab2HBKee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:34:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40213 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2HBKec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:34:32 -0400
Date: Thu, 2 Aug 2012 03:34:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Francois Rigaut <frigaut@mso.anu.edu.au>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, bhelgaas@google.com
Subject: Re: [PATCH V2 1/4] EFI: Stash ROMs if they're not in the PCI BAR
Message-ID: <20120802103423.GA1921@kroah.com>
References: <1343407934-459-1-git-send-email-mjg@redhat.com>
 <20120731223240.GD19134@kroah.com>
 <20120801165400.GA3042@srcf.ucam.org>
 <20120801232147.GA6228@kroah.com>
 <20120802040242.GB25933@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120802040242.GB25933@thinkpad-t410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 11:02:42PM -0500, Seth Forshee wrote:
> On Wed, Aug 01, 2012 at 04:21:47PM -0700, Greg KH wrote:
> > On Wed, Aug 01, 2012 at 05:54:00PM +0100, Matthew Garrett wrote:
> > > On Tue, Jul 31, 2012 at 03:32:40PM -0700, Greg KH wrote:
> > > 
> > > > With this series, does the latest MacBook work properly for the Intel
> > > > graphics driver?  Or is this to resolve some other hardware issue?
> > > 
> > > Apple only seem to provide the ROM for the radeon. Intel normally 
> > > stands a much better chance of working without a ROM - the only thing it 
> > > really uses it for is the VBT, and I'm thinking about a couple of ways 
> > > of handlng that.
> > 
> > Ok, thanks for letting me know.  For some reason, the gmux isn't working
> > on the latest MacBook Pro so I can't get the vga switched to the Intel
> > PCI device.  Rumor has it the osx tool at
> > http://codykrieger.com/gfxCardStatus will switch into the Intel chip
> > until the laptop is hard powered off, so it is possible, just need to
> > figure out how to make the hardware do the switch...
> 
> There's a tool that enables some verbose logging which records all the
> I/O to the gmux. It works for me with a Macbook Pro 8,2 running OS X
> Lion, so you might give it a try.
> 
> All you need to do is clone https://github.com/ah-/switcher.git, build,
> and run switcher. If it works you'll see messages prefixed with AGC in
> dmesg. Then you can use gfxCardStatus to force some switches between the
> integrated and discrete cards. After that you'll want to grab
> /var/log/kern.log to get the full logs of everything that happened.
> 
> If you try this and it works, I'd appreciate it if you could send me a
> copy of kern.log so I can apply the information towards getting graphics
> switching into apple-gmux.

Francois, any chance you can ty this and let Seth know the results?  I
don't have OSX on my machine anymore to do this myself.

thanks,

greg k-h
