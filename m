Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab1IVR6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:58:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab1IVR6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:58:07 -0400
Date: Thu, 22 Sep 2011 10:36:18 -0700
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: Hyper-V TODO file
Message-ID: <20110922173618.GA5624@suse.de>
References: <1316708240-25048-1-git-send-email-kys@microsoft.com>
 <20110922170450.GA4490@suse.de>
 <6E21E5352C11B742B20C142EB499E048081E935D@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081E935D@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 05:20:59PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@suse.de]
> > Sent: Thursday, September 22, 2011 1:05 PM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > virtualization@lists.osdl.org
> > Subject: Re: Hyper-V TODO file
> > 
> > On Thu, Sep 22, 2011 at 09:17:20AM -0700, K. Y. Srinivasan wrote:
> > >
> > > Greg,
> > >
> > > With your last checkin of the patches for Hyper-V, I have addressed all of
> > > the issues you had raised as part of the vmbus audit. Should I send you a
> > > patch to update the TODO file to reflect this. Let me know.
> > 
> > Yes, please send patches.
> 
> Thanks Greg. In addition to the patch to update the TODO file, do you want me to
> send you patches for moving the vmbus and util driver out of staging as well.

No, I'll do that if we agree that it is ready to do so.

thanks,

greg k-h
