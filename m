Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab1ECRd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:33:28 -0400
Received: from kroah.org ([198.145.64.141]:56683 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab1ECRd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:33:27 -0400
Date: Tue, 3 May 2011 10:33:09 -0700
From: Greg KH <greg@kroah.com>
To: Peter Foley <pefoley2@verizon.net>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        hjanssen@microsoft.com, haiyangz@microsoft.com
Subject: Re: [PATCH] staging: hv: make HYPERV_UTILS depend on NLS to prevent
 a build error
Message-ID: <20110503173309.GA25014@kroah.com>
References: <4DB60932.6090000@verizon.net>
 <20110426000024.GB11787@suse.de>
 <4DB61786.2030307@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB61786.2030307@verizon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 08:53:26PM -0400, Peter Foley wrote:
> On 4/25/2011 8:00 PM, Greg KH wrote:
> > On Mon, Apr 25, 2011 at 07:52:18PM -0400, Peter Foley wrote:
> >> This patch adds a dependency on NLS to HYPERV_UTILS to avoid a build error.
> > 
> > What is the build error?
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> When CONFIG_HYPERV_UTILS=y and CONFIG_NLS=n
> the build fails with this error:
> 
>  Building modules, stage 2.
>   MODPOST 3 modules
> ERROR: "utf8s_to_utf16s" [drivers/staging/hv/hv_utils.ko] undefined!
> make[3]: *** [__modpost] Error 1
> make[2]: *** [modules] Error 2
> make[2]: *** Waiting for unfinished jobs....
> Kernel: arch/x86/boot/bzImage is ready  (#2)
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2

Ah, ok, we need this for that function, that's what I wanted to know,
I'll put it in the changelog entry.  Please do that the next time.

thanks,

greg k-h
