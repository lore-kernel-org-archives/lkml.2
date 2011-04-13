Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab1DMDmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 23:42:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756932Ab1DMDmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 23:42:01 -0400
Date: Tue, 12 Apr 2011 20:40:43 -0700
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: irq allocation for pci drivers
Message-ID: <20110413034043.GA813@suse.de>
References: <6E21E5352C11B742B20C142EB499E0481CB17E@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481CB17E@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 11:57:22PM +0000, KY Srinivasan wrote:
> Greg,
> 
>  
> 
> Has something changed in the PCI code in the Linux-next tree – 2.6.39-rc1-12
> with
> 
> regards to irq allocation? Earlier (a few weeks ago), the vmbus driver would
> get the irq allocated as part
> 
> of it being now a pci driver. Currently, however the system is setting pdev->
> irq to
> 
> 0 and needless to say, request_irq() is failing.

{sigh}  Please fix your email client...

Anyway, I have no idea, please use 'git bisect' to track down the
problem commit that causes this.

thanks,

greg k-h
