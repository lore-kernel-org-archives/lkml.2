Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab1BYAf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 19:35:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab1BYAf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 19:35:27 -0500
Date: Thu, 24 Feb 2011 16:31:36 -0800
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH ] Staging: hv:  Hyper-V driver cleanup
Message-ID: <20110225003136.GA27272@suse.de>
References: <1298589658-23126-1-git-send-email-kys@microsoft.com>
 <20110224234541.GA23711@suse.de>
 <6E21E5352C11B742B20C142EB499E04801522A@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E04801522A@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 12:24:57AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@suse.de]
> > Sent: Thursday, February 24, 2011 6:46 PM
> > To: KY Srinivasan
> > Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > virtualization@lists.osdl.org; Haiyang Zhang; Hank Janssen
> > Subject: Re: [PATCH ] Staging: hv: Hyper-V driver cleanup
> > 
> > On Thu, Feb 24, 2011 at 03:20:58PM -0800, K. Y. Srinivasan wrote:
> > > This patch cleans up (a lot of the) naming issues that
> > > various reviewers have noted. It also gets rid of
> > > some unnecessary layering in the code.
> > 
> > Whenever you have a patch description that says "It also..." you know
> > you need to break this up into smaller, logical pieces.
> 
> The name change was related to the layering issue. For instance I combined the 
> Vm_device and hv_device abstractions to build the hyperv_device abstraction.
> Likewise, I combined the driver_context and the hv_driver abstractions to build the 
> the hyperv_driver abstraction. Would breaking this patch up into two patches,
> one dealing with the device abstraction consolidation and the other dealing with
> the consolidation of driver abstractions satisfy your concern. Even if I partition this 
> patch along these lines, it will still be a large set of patches; since these changes 
> are pervasive. 

pervasive patches are fine, just remember, "each patch can only do one
thing".  It sounds like you want to do at least 2 patches here, if not
a lot more.  Look at my past patches when I combined things and removed
a whole layer for how to do this in a very incremental, piece-by-piece
fashion (i.e, move one field over at a time until the structure is gone,
and then remove it entirely.)

> > There is no 2.6.38 kernel yet, so I find this very hard to believe :)
> 
> My mistake; I did not specify the full output of uname -a on the box 
> that I tested this code. This box is running the LINUX-NEXT kernel :
> 2.6.38-rc1-0.2-default.

linux-next should be farther along than -rc1 as -rc6 is currently out.

confused,

greg k-h
