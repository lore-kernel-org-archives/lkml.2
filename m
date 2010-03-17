Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab0CQEez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 00:34:55 -0400
Received: from kroah.org ([198.145.64.141]:42573 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab0CQEex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 00:34:53 -0400
Date: Tue, 16 Mar 2010 21:30:06 -0700
From: Greg KH <greg@kroah.com>
To: Crane Cai <crane.cai@amd.com>, Alex Chiang <achiang@hp.com>,
       sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] USB: xhci: rename driver to xhci_hcd
Message-ID: <20100317043006.GC21125@kroah.com>
References: <20100316204845.GJ8278@ldl.fc.hp.com> <20100317022228.GB2138@crane-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100317022228.GB2138@crane-desktop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 10:22:28AM +0800, Crane Cai wrote:
> On Tue, Mar 16, 2010 at 02:48:45PM -0600, Alex Chiang wrote:
> > Naming consistency with other USB HCDs.
> 
> I don't know the value of this changes. 
> I think we do not need to make this change, only make xhci.ko to
> xhci-hcd.ko.

It makes things consistant.

> Any way this depends on Sarah.

As the patch noted, Sarah asked for this change :)

It's now in my tree.

thanks,

greg k-h
