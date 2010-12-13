Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0LMUVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 15:21:15 -0500
Received: from kroah.org ([198.145.64.141]:32873 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab0LMUVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 15:21:15 -0500
Date: Mon, 13 Dec 2010 12:18:43 -0800
From: Greg KH <greg@kroah.com>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] hv: Use only one receive buffer and kmalloc on
 initialize
Message-ID: <20101213201843.GA19409@kroah.com>
References: <1292262350-29001-1-git-send-email-hjanssen@microsoft.com>
 <20101213183448.GA11745@kroah.com>
 <8AFC7968D54FB448A30D8F38F259C5622C0BB71F@TK5EX14MBXC116.redmond.corp.microsoft.com>
 <20101213194101.GA18431@kroah.com>
 <8AFC7968D54FB448A30D8F38F259C5622C0BC809@TK5EX14MBXC116.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C5622C0BC809@TK5EX14MBXC116.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 08:06:20PM +0000, Hank Janssen wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Monday, December 13, 2010 11:41 AM
> > > The current versions of Hyper-V support interrupt handling on CPU0 only.
> > > I can make multiple buffers per channel, but because of Hyper-V
> > > implementation It does not really make a difference.
> > 
> > Then put a big fat note in there saying this, and that it will have to change if
> > the hyperv channel ever changes.
> > 
> > Hm, how will you handle things if the hyperv core changes and an old kernel
> > is running this code where things were "assumed" about the reentrancy
> > happening here?
> 
> I will re-roll this patch to have a buffer per channel. It is a more elegant design
> Even though Hyper-V behavior is not changing in Win8 for this.

Win8, fine, but what about Win9?  :)

thanks for changing it.

greg k-h
