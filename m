Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560Ab0EDQGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 12:06:07 -0400
Received: from kroah.org ([198.145.64.141]:41198 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933411Ab0EDQGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 12:06:01 -0400
Date: Tue, 4 May 2010 08:52:16 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATCH: Fix up memrar to the new RAR API
Message-ID: <20100504155216.GA26209@kroah.com>
References: <20100504105213.629fcb00@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504105213.629fcb00@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 10:52:13AM +0100, Alan Cox wrote:
> memrar: rework to match the RAR API changes
> 
> From: Alan Cox <alan@linux.intel.com>
> 
> Fix various unload related bugs
> Use the per RAR allocator/deallocator
> Add kerneldoc

This doesn't apply now that the previous patch could not be applied due
to the build error.

Care to fix these two up and send them again?

thanks,

greg k-h
