Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab0EDCyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 22:54:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab0EDCyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 22:54:31 -0400
Date: Mon, 3 May 2010 19:54:30 -0700
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Staging: dt3155: Cleanup memory mapped i/o access
Message-ID: <20100504025430.GA26421@suse.de>
References: <0D753D10438DA54287A00B0270842697636DAFCD14@AUSP01VMBX24.collaborationhost.net> <20100430215645.GA12409@kroah.com> <0D753D10438DA54287A00B0270842697636E9B9B0D@AUSP01VMBX24.collaborationhost.net> <20100503185933.GA27346@kroah.com> <0D753D10438DA54287A00B0270842697636EADDEC0@AUSP01VMBX24.collaborationhost.net> <20100503211751.GB21402@kroah.com> <0D753D10438DA54287A00B0270842697636EADE1D2@AUSP01VMBX24.collaborationhost.net> <0D753D10438DA54287A00B0270842697636EADE26A@AUSP01VMBX24.collaborationhost.net> <20100503234123.GC13519@suse.de> <1272931198.30040.218.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272931198.30040.218.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 04:59:58PM -0700, Joe Perches wrote:
> On Mon, 2010-05-03 at 16:41 -0700, Greg KH wrote:
> > No, wait, I see these in my staging-next tree here.  Some of them I
> > wrote :)
> 
> There not there.
> 
> git push?

I have, and they look to be there to me:
  http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-next-2.6.git;a=commit;h=4f923d004396ef272600d381a365cac9d832486d

So something must be odd on your side.

thanks,

greg k-h
