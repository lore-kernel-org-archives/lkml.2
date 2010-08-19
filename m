Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab0HSPWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:22:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:45366 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab0HSPWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:22:09 -0400
Date: Thu, 19 Aug 2010 08:17:12 -0700
From: Greg KH <gregkh@suse.de>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, LKML <linux-kernel@vger.kernel.org>,
        yong.y.wang@intel.com, qi.wang@intel.com,
        andrew.chih.howe.khor@intel.com, arjan@linux.intel.com,
        alan@linux.intel.com, margie.foster@intel.com
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Message-ID: <20100819151712.GC2562@suse.de>
References: <4C6BA385.80409@dsn.okisemi.com> <20100818131401.GA5861@suse.de> <000401cb3f67$9936adf0$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000401cb3f67$9936adf0$66f8800a@maildom.okisemi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 03:27:23PM +0900, Masayuki Ohtake wrote:
> Hi Greg,
> 
> Thank you for your comments.
> > > +#define MODULE_NAME "pch_phub"
> >
> > This isn't needed, right?  The kernel provides this to you in the build
> > service automatically.
> 
> I can't understand above enough.
> Is the above mean  like below ?
> 
> * Delete the following line.
> > > +#define MODULE_NAME "pch_phub"
> 
>  * Modify the following line(Use "pch_phub" directly)
> > > + ret = pci_request_regions(pdev, "pch_phub");

No, use the variable that the build system provides to you,
KBUILD_MODNAME

thanks,

greg k-h
