Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0C3W7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 18:59:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:39398 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab0C3W7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 18:59:44 -0400
Date: Tue, 30 Mar 2010 15:11:39 -0700
From: Greg KH <gregkh@suse.de>
To: "L. Alberto Gim?nez" <agimenez@sysvalve.es>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, alan@linux.intel.com
Subject: Re: [PATCH] Staging: Add new driver ipheth
Message-ID: <20100330221138.GA20765@suse.de>
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es> <1269984864-28159-2-git-send-email-agimenez@sysvalve.es> <20100330214509.GA1388@suse.de> <4BB273FE.8010004@sysvalve.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB273FE.8010004@sysvalve.es>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 11:58:22PM +0200, "L. Alberto Gim?nez" wrote:
> On 03/30/2010 11:45 PM, Greg KH wrote:
> > On Tue, Mar 30, 2010 at 11:34:24PM +0200, L. Alberto Gim??nez wrote:
> >> Add new driver to use tethering with an iPhone device to the staging tree.
> > 
> > Why the staging tree?
> > 
> > What is wrong with the driver that it needs to go there and not to the
> > main kernel tree?
> > 
> 
> Sorry, I thought that the first step was getting into staging.

For the majority of the drivers out there, no, this is not the first
step.  Especially ones as clean as this one.  Staging is only for the
"crap" code out there :)

> I ignored the fact that it needed a TODO file. I'm not either sure
> about where should it go since it uses the USB interface but in fact
> is used as a network device (drivers/net? drivers/usb?). My guess is
> drivers/net, but I'm pretty sure I'm wrong :)

drivers/net/usb/ would be the proper place for it.

> > Did you write this driver?  If not, please put a "From:" line that shows
> > who did write it.
> 
> Should I just add a "From: " email-like header in the patch, in the
> commit or in the body? I'm not sure how to do it.

Put it as the first line of the changelog comment in the email body, and
then when git applies it, the proper author will be credited.

care to try it again?

thanks,

greg k-h
