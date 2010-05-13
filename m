Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427Ab0EMTHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:07:12 -0400
Received: from kroah.org ([198.145.64.141]:42396 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758887Ab0EMTHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:07:06 -0400
Date: Thu, 13 May 2010 12:06:36 -0700
From: Greg KH <greg@kroah.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jbarnes@virtuousgeek.org,
       matthew@wil.cx, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, ddutile@redhat.com, alex.williamson@redhat.com
Subject: Re: [PATCH 2/2 v2] pci: check caps from sysfs file open to read
 device dependent config space
Message-ID: <20100513190636.GC5979@kroah.com>
References: <20100513012857.GA28034@sequoia.sous-sol.org>
 <20100513012957.GB28034@sequoia.sous-sol.org>
 <20100513105911.6469c434@lxorguk.ukuu.org.uk>
 <20100513174307.GH28034@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513174307.GH28034@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 10:43:07AM -0700, Chris Wright wrote:
> * Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > I agree with the problem - but IMHO the fix is to require opening the file
> > checks CAP_SYS_something instead: not to hack the read method and make it
> > even weirder and more un-Linux than it is now.
> 
> This patch does that.  Not as convenient from the KVM/libvirt point of view
> because it is not prepared to do this setup before dropping privileges
> and launching the VM.

So does that mean that this patch doesn't solve your original problem
here?

thanks,

greg k-h
