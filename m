Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab0I0GNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 02:13:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:43184 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668Ab0I0GNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 02:13:50 -0400
Date: Sun, 26 Sep 2010 23:10:29 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Greg KH <greg@kroah.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 1/1] Rename camel case variables in channel.c  (updated
	again)
Message-ID: <20100927061029.GC22319@suse.de>
References: <1FB5E1D5CA062146B38059374562DF7289ED89CF@TK5EX14MBXC130.redmond.corp.microsoft.com> <1FB5E1D5CA062146B38059374562DF7289EDBC9E@TK5EX14MBXC130.redmond.corp.microsoft.com> <20100927011943.GA6936@kroah.com> <1FB5E1D5CA062146B38059374562DF7289F076BD@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7289F076BD@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 02:52:20AM +0000, Haiyang Zhang wrote:
> > From: Greg KH [mailto:greg@kroah.com]
> > This patch is mime-encoded and I'm getting tired of having to convert
> > it
> > before I can apply it.
> > 
> > Can you please fix up your email client/server to not do this?  I
> > should
> > be able to take the raw email and apply the patch with the 'patch'
> > command.
> > 
> > And yes, I know git-am handles mime messages and I use it to apply the
> > patch, but I still use 'patch' to verify things are sane before
> > commiting the patch for real.
> > 
> > Care to resend?
> 
> I checked the email I sent on Friday, it was in "Plain Text" format.
> This was the same format I used for my patches which were accepted
> previously. Maybe Outlook server converted this one to MIME format?
> I'm not sure.
> 
> I have attached the patch in Linux text format, which I have verified
> with 'patch' command. No error:
> 
> linux-next> patch -p1 <0924.2-Rename-camel-case-variables-in-channel.c.patch
> patching file drivers/staging/hv/channel.c
> linux-next>
> 
> Could you try the attached patch on your side?

Yes, that worked, but you do realize you attached it in base64 mode,
right?  That sure isn't going to work...

thanks,

greg k-h
