Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab1EDS7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:59:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:48383 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653Ab1EDS7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:59:53 -0400
Date: Wed, 4 May 2011 11:59:45 -0700
From: Greg KH <gregkh@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] Staging: hv: Add the necessary dependencies to
 hyperv Kconfig
Message-ID: <20110504185945.GA15032@suse.de>
References: <1304535105-26892-1-git-send-email-kys@microsoft.com>
 <20110504185142.GA28458@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504185142.GA28458@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 02:51:42PM -0400, Christoph Hellwig wrote:
> On Wed, May 04, 2011 at 11:51:45AM -0700, K. Y. Srinivasan wrote:
> >  config HYPERV
> >  	tristate "Microsoft Hyper-V client drivers"
> > -	depends on X86 && m
> > +	depends on X86 && ACPI && PCI && m
> 
> I can't see anything preventing this driver from beeing built-in,
> so the "depends on m" should probably go away.

Originally there were some problems with some bad global symbols.
Hopefully those should all be resolved now, but it can't hurt to review
the code to verify this first.

thanks,

greg k-h
