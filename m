Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab0LMVrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:47:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:56884 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757542Ab0LMVrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:47:15 -0500
Date: Mon, 13 Dec 2010 13:47:06 -0800
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: Jesper Juhl <jj@chaosbits.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Ky Srinivasan <ksrinivasan@novell.com>
Subject: Re: [PATCH 1/1] hv: Use only one txf buffer per channel and
 kmalloc on initialize
Message-ID: <20101213214706.GA20991@suse.de>
References: <1292274861-29673-1-git-send-email-hjanssen@microsoft.com>
 <alpine.LNX.2.00.1012132220220.26491@swampdragon.chaosbits.net>
 <8AFC7968D54FB448A30D8F38F259C5622C0BCDFC@TK5EX14MBXC116.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C5622C0BCDFC@TK5EX14MBXC116.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 09:31:09PM +0000, Hank Janssen wrote:
> 
> > From: Jesper Juhl [mailto:jj@chaosbits.net]
> > Sent: Monday, December 13, 2010 1:22 PM
> > 
> > I can't spot any problems with these changes now, so feel free to add
> >   Reviewed-by: Jesper Juhl <jj@chaosbits.net> if you like.
> > 
> 
> Thank you for your help Jesper.
> 
> Greg, do you want me to resubmit with the Reviewed by line? Or do you 
> Add it once you queue it up for linux-next?

I add it when I apply it.

thanks,

greg k-h
