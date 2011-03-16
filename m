Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1CPUbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:31:34 -0400
Received: from kroah.org ([198.145.64.141]:48685 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761Ab1CPUba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:31:30 -0400
Date: Wed, 16 Mar 2011 13:31:19 -0700
From: Greg KH <greg@kroah.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [ANNOUNCE] usbmon capture and parser script
Message-ID: <20110316203119.GA3994@kroah.com>
References: <4D8102A9.9080202@redhat.com>
 <20110316194758.GA32557@kroah.com>
 <1300306845.1954.7.camel@t41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300306845.1954.7.camel@t41.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 09:20:24PM +0100, Paul Bolle wrote:
> On Wed, 2011-03-16 at 12:47 -0700, Greg KH wrote:
> > Very cool stuff.  You are away of:
> > 	http://vusb-analyzer.sourceforge.net/
> > right?
> > 
> > I know you are doing this in console mode, but it looks close to the
> > same idea.
> 
> Perhaps there should be some references to vusb-analyzer and similar
> tools in Documentation/usb/usbmon.txt (it now only mentions "usbdump"
> and "USBMon"). I remember looking for a tool like that (ie, a parser)
> for quite some time before stumbling onto vusb-analyzer.

Patches are always gladly welcome, especially for documentation :)

thanks,

greg k-h
