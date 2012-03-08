Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab2CHSih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:38:37 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:38006 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab2CHSif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:38:35 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFHjS0PFKx8
X-RZG-CLASS-ID: mo00
Date: Thu, 8 Mar 2012 19:38:20 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Greg KH <greg@kroah.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH] net/hyperv: Advertise hv_netvsc instead of netvsc as
 driver name
Message-ID: <20120308183820.GA25015@aepfle.de>
References: <1331147131-6660-1-git-send-email-haiyangz@microsoft.com>
 <20120307201746.GA20900@aepfle.de>
 <20120307204946.GA4413@kroah.com>
 <20120308061615.GA25237@aepfle.de>
 <20120308155219.GC5907@kroah.com>
 <20120308161221.GA31415@aepfle.de>
 <20120308174220.GB17192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120308174220.GB17192@kroah.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, Greg KH wrote:

> On Thu, Mar 08, 2012 at 05:12:21PM +0100, Olaf Hering wrote:
> > On Thu, Mar 08, Greg KH wrote:
> > 
> > > > hwinfo uses it to recognize a network interface (storage in case of
> > > > hv_storvsc).
> > > 
> > > That tool should report the real module name, not rely on the name to
> > > match based on the structure, if you really care about the real module
> > > name.
> > 
> > Its about the driver symlink, not the module name. 
> > 
> > I think most, if not all, (relevant) drivers use some sort of
> > KBUILD_MODNAME. Why should this driver be any different?
> 
> It shouldn't, I'm not saying that at all.  I'm only objecting to the
> insistance that this be something worthwhile for 3.3-final which should
> be out any day now.

Since its an API we could settle on the new string, which is already in
distro use.

Olaf
