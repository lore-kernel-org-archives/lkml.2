Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833Ab1CCVWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:22:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab1CCVWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:22:21 -0500
Date: Thu, 3 Mar 2011 13:22:12 -0800
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 4/6] Staging: hv:  Unify the hyperv driver abstractions
Message-ID: <20110303212212.GA507@suse.de>
References: <1298686023-30892-1-git-send-email-kys@microsoft.com>
 <20110301025230.GE1663@kroah.com>
 <6E21E5352C11B742B20C142EB499E04801661A@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20110302054125.GB28382@kroah.com>
 <6E21E5352C11B742B20C142EB499E048016A13@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20110303061002.GD32209@suse.de>
 <6E21E5352C11B742B20C142EB499E048016CD9@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048016CD9@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 09:16:29PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@suse.de]
> > Sent: Thursday, March 03, 2011 1:10 AM
> > To: KY Srinivasan
> > Cc: Greg KH; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > virtualization@lists.osdl.org; Haiyang Zhang; Hank Janssen
> > Subject: Re: [PATCH 4/6] Staging: hv: Unify the hyperv driver abstractions
> > 
> > On Thu, Mar 03, 2011 at 02:50:00AM +0000, KY Srinivasan wrote:
> > > > > > "struct driver_context"?  Oh please no.
> > > > >
> > > > > Greg; this is the patch that consolidates the state in  struct hv_driver into
> > > > > struct driver_context. In the spirit of doing one thing in a patch;
> > > > > other relevant changes are made in:
> > > > > Patch[5/6]: Changes the name driver_context to hyperv_driver
> > > > > Patch[6/6]: Cleanup all variable names that refer to struct hyperv_driver.
> > > >
> > > > Yes, but on its own, this patch is wrong, that is not a valid name, even
> > > > if it is a "temporary" name.
> > >
> > > Greg, the temporary name happens to be the name currently in use in the
> > > code - this is not the name I introduced.
> > 
> > There is not a "struct driver_context" in the code that I see today, or
> > am I missing something?  That's my objection here, please don't use that
> > name, it's not valid for a subsystem to use, even for a tiny bit.
> 
> Look at the file vmbus.h  you will see struct driver_context. This has
> been there for as long as I have seen this code. 

Ok, I am rightly corrected, I totally missed that, you are right.

Feel free to resend after addressing the other issues.

I'll fix up the hv_mouse driver, you don't have to worry about that one
if you don't want to, just ignore it please.

thanks,

greg k-h
