Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966273Ab2EQNc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 09:32:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56263 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab2EQNc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 09:32:27 -0400
Date: Thu, 17 May 2012 06:32:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>
Subject: Re: [PATCH] staging: comedi: Convert struct addi_board
 initialization to C99 format
Message-ID: <20120517133221.GB5090@kroah.com>
References: <201205161751.56913.hartleys@visionengravers.com>
 <20120517021805.GA32592@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F00206986FBDDF@AUSP01VMBX24.collaborationhost.net>
 <4FB49E74.8030409@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB49E74.8030409@mev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 07:45:08AM +0100, Ian Abbott wrote:
> On 17/05/12 07:15, H Hartley Sweeten wrote:
> >Wednesday, May 16, 2012 7:18 PM, Greg KH wrote:
> >>On Wed, May 16, 2012 at 05:51:56PM -0700, H Hartley Sweeten wrote:
> >>>Convert the struct addi_board initialization to C99 format and remove
> >>>all the NULL or 0 initializers. This makes maintaining and editing the
> >>>code simpler and less error prone.
> >>Nice job, this driver is a pain to read...
> >
> >Thanks. I agree... I've been avoiding the addi drivers until now.
> >Anytime a C file has an #include "something.c" it makes me
> >shudder...
> >
> >I've been thinking that the addi stuff should really be broken up
> >into some library modules with exported symbols for the individual
> >addi drivers to use. I need to look a bit closer at them to see if
> >this would work. Right now the whole thing is a bit of a mess.
> 
> TBH, I don't know how they got accepted into Comedi in the first
> place.  They tend to do their own thing as far as comedi instruction
> handling goes.  I've no idea who's using them.  It makes me shudder,
> too!  Did I mention the use of floating point in some of their
> drivers that we had to disable?

I thought a few years ago, either you, or someone else, said it would be
good to just delete them entirely.  Or am I making that up and just wish
it would be so?  :)

thanks,

greg k-h
