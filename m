Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab0LBP3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 10:29:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:55636 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123Ab0LBP3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 10:29:05 -0500
Date: Thu, 2 Dec 2010 07:16:42 -0800
From: Greg KH <gregkh@suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg KH <greg@kroah.com>, Ben Hutchings <bhutchings@solarflare.com>,
        erazor_de@users.sourceforge.net, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/5] HID: roccat: declaring meaning of pack pragma
 usage in driver headers
Message-ID: <20101202151642.GA15449@suse.de>
References: <1290801456.18750.164.camel@neuromancer>
 <1290804616.3051.52.camel@localhost>
 <20101130174052.GA19977@kroah.com>
 <alpine.LNX.2.00.1012021604110.14806@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1012021604110.14806@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 04:04:35PM +0100, Jiri Kosina wrote:
> On Tue, 30 Nov 2010, Greg KH wrote:
> 
> > > > Using pack pragma to prevent padding bytes in binary data structures
> > > > used for hardware communication. Explanation of these pragmas was requested.
> > > [...]
> > > 
> > > It would be clearer to use the '__packed' macro after each structure
> > > definition instead of using this awful Microsoft extension.
> > 
> > I agree, that's the "normal" Linux way of doing things.
> > 
> > Other than that, this patch set looks good to me.  Jiri, if the packed
> > change is made, do you want me to take these through my tree, or do you
> > want to take them through yours?  Whatever is easier for you is fine
> > with me.
> 
> Hi Greg,
> 
> as this is part of larger roccat patchset, I will be processing it through 
> my tree once completely reviewed.

Great, feel free to add my:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to the driver core changes.

thanks,

greg k-h
