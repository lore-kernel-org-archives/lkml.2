Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab0CPTH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 15:07:56 -0400
Received: from kroah.org ([198.145.64.141]:50262 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745Ab0CPTFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 15:05:42 -0400
Date: Tue, 16 Mar 2010 12:03:14 -0700
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>
Cc: sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] USB: xhci: rename driver to xhci_hcd
Message-ID: <20100316190314.GB32555@kroah.com>
References: <20100309174815.29339.96173.stgit@bob.kio> <20100309175249.29339.7519.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309175249.29339.7519.stgit@bob.kio>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 10:52:49AM -0700, Alex Chiang wrote:
> Naming consistency with other USB HCDs.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>

This doesn't apply to the 2.6.34-rc1 kernel.  Care to redo it so that I
can apply it?

thanks,

greg k-h
