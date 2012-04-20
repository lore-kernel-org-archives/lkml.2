Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab2DTPdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:33:38 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49922 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab2DTPdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:33:37 -0400
Date: Fri, 20 Apr 2012 08:33:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ian Abbott <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
Subject: Re: [PATCH v2] staging: comedi: resolve section mismatch in s626
Message-ID: <20120420153331.GA19219@kroah.com>
References: <20120319030925.GB22956@perelman.Home>
 <20120319163103.GC3694@kroah.com>
 <20120319164325.GA31833@perelman.Home>
 <20120319224649.GA7679@perelman.Home>
 <20120319232656.GB6386@kroah.com>
 <4F798416.8040709@mev.co.uk>
 <20120410182438.GB2052@kroah.com>
 <4F86D294.3050108@mev.co.uk>
 <20120418232824.GA9419@kroah.com>
 <20120420013411.GA3769@cantor.Home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120420013411.GA3769@cantor.Home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 06:34:11PM -0700, Gerard Snitselaar wrote:
> I am getting an error when doing a build of the latest linux-next
> before it gets to modpost so I need to look at that, but when I do an
> allyesconfig build on master I get the following:
> 
> WARNING: drivers/staging/comedi/drivers/s626.o(.text+0x2ec8): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table
> The function s626_attach() references
> the variable __devinitconst s626_pci_table.
> This is often because s626_attach lacks a __devinitconst 
> annotation or the annotation of s626_pci_table is wrong.
> 
> WARNING: drivers/staging/comedi/drivers/s626.o(.text+0x2ece): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table
> The function s626_attach() references
> the variable __devinitconst s626_pci_table.
> This is often because s626_attach lacks a __devinitconst 
> annotation or the annotation of s626_pci_table is wrong.
> 
> WARNING: drivers/staging/comedi/drivers/s626.o(.text+0x2ed7): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table
> The function s626_attach() references
> the variable __devinitconst s626_pci_table.
> This is often because s626_attach lacks a __devinitconst 
> annotation or the annotation of s626_pci_table is wrong.
> 
> WARNING: drivers/staging/comedi/drivers/s626.o(.text+0x2edd): Section mismatch in reference from the function s626_attach() to the variable .devinit.rodata:s626_pci_table
> The function s626_attach() references
> the variable __devinitconst s626_pci_table.
> This is often because s626_attach lacks a __devinitconst 
> annotation or the annotation of s626_pci_table is wrong.

Odd, can you send me your .config file?

Also, I don't have this patch in my queue anymore, can someone please
resend it if it is to be applied?

greg k-h
