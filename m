Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2HZCB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 22:01:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:65309 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab2HZCB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 22:01:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,313,1344236400"; 
   d="scan'208";a="214001368"
Date: Sat, 25 Aug 2012 19:01:23 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alex Shi <alex.shi@intel.com>
Cc: gregkh <gregkh@linuxfoundation.org>,
        Alan stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/xhci: unify parameter of xhci_msi_irq
Message-ID: <20120826020123.GG6557@xanatos>
References: <1331787186.2979.71.camel@debian>
 <20120315145743.GA7928@kroah.com>
 <4F6204B7.5010908@intel.com>
 <20120315175608.GA6077@xanatos>
 <4FC5D04E.5040907@intel.com>
 <4FD59AD8.1050109@intel.com>
 <20120611204709.GC5742@xanatos>
 <20120611211428.GB24904@kroah.com>
 <502897A4.4030601@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502897A4.4030601@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 01:59:00PM +0800, Alex Shi wrote:
> On 06/12/2012 05:14 AM, gregkh wrote:
> 
> > On Mon, Jun 11, 2012 at 01:47:09PM -0700, Sarah Sharp wrote:
> >> Hi Alex,
> >>
> >> This got lost in the 3.5 push, but I think it's a good candidate for
> >> 3.6.  I think Greg is accepting 3.6 patches now, and I'll send this off
> >> to him.
> > 
> > Yes, I am taking 3.6 stuff now.  In the future, once -rc1 is out, I can
> > take patches for the next release at that point in time.
> > 
> > greg k-h
> > 
> 
> 
> Didn't find the patch in upstream 3.6-rc, but it is still workable for
> upstream kernel.
> So, was you just going to apply it on 3.7 kernel?  or just forget it?

Hi Alex,

I am human, and trying my human best to keep up as a maintainer.  Bug
fixes and big features take priority over the small improvements, and
I'm sorry that your patch (and other patches) have fallen by the
wayside.  It is not personal, I simply cannot be perfect.

I will be returning to full maintainership duties after the various
Linux conferences next week, and I will do my best to get your patch
merged.

Sarah Sharp
