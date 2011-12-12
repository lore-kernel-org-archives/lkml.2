Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1LLXvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:51:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746Ab1LLXvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:51:05 -0500
Date: Mon, 12 Dec 2011 15:49:18 -0800
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 4/4] Drivers: hv: Support building the vmbus driver as
 part of the kernel
Message-ID: <20111212234918.GA20625@suse.de>
References: <1323710931-29616-1-git-send-email-kys@microsoft.com>
 <1323710959-29655-1-git-send-email-kys@microsoft.com>
 <1323710959-29655-4-git-send-email-kys@microsoft.com>
 <20111212222712.GA13510@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481AD7FDDF@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481AD7FDDF@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 11:44:30PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Monday, December 12, 2011 5:27 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> > Haiyang Zhang
> > Subject: Re: [PATCH 4/4] Drivers: hv: Support building the vmbus driver as part of
> > the kernel
> > 
> > On Mon, Dec 12, 2011 at 09:29:19AM -0800, K. Y. Srinivasan wrote:
> > > Support building the vmbus driver as part of the kernel.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > 
> > This was already applied to my tree, I don't know why you missed it...
> 
> Thanks Greg. I pulled down your tree yesterday (staging.git) and checked out
> the staging-next branch and did not find the fix needed to build this driver
> as part of the kernel. I will check again.

That is because I'm not applying these patches to the staging.git tree,
as the commit messages you get show...

