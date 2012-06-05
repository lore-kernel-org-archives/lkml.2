Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2FEGQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 02:16:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54620 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab2FEGQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 02:16:02 -0400
Date: Mon, 4 Jun 2012 20:23:14 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
Subject: Re: [PATCH] staging: comedi: remove private header comedi_pci.h
Message-ID: <20120605032314.GB32598@kroah.com>
References: <201205211712.12753.hartleys@visionengravers.com>
 <4FBB6520.10305@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBB6520.10305@mev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 11:06:24AM +0100, Ian Abbott wrote:
> On 2012-05-22 01:12, H Hartley Sweeten wrote:
> >Remove the private header, comedi_pci.h, by moving the two
> >helper functions into divers.c and providing the prototypes
> >in comedidev.h.
> >
> >This allows the comedi_pci_enable/disable helper functions
> >to be shared instead of having an inline version in every
> >comedi pci driver.
> 
> I'm wondering if these functions should be EXPORT_SYMBOL() or
> EXPORT_SYMBOL_GPL() since they were originally inline functions.
> 
> Opinions?

Are there any known out-of-tree comedi drivers?  I say leave this as-is
and see if anyone complains :)

thanks,

greg k-h
