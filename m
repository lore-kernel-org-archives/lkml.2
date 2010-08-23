Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0HWWrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 18:47:12 -0400
Received: from kroah.org ([198.145.64.141]:38464 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab0HWWrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 18:47:10 -0400
Date: Mon, 23 Aug 2010 15:43:04 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Christian Samsel <Christian.Samsel@rwth-aachen.de>,
        LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [stable] runaway loop modprobe char-major-5-1 has returned?
Message-ID: <20100823224304.GJ13371@kroah.com>
References: <201008181143.04629.Christian.Samsel@rwth-aachen.de>
 <4C6C2DE9.2000509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6C2DE9.2000509@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 09:00:57PM +0200, Jiri Slaby wrote:
> On 08/18/2010 11:43 AM, Christian Samsel wrote:
> > Hi,
> > I wanted to build a minimal kernel as Xen DomU, but stumbled across
> > 
> > [    0.029457] VFS: Disk quotas dquot_6.5.2
> > [    0.029559] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> > [    0.029973] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> > [    0.030662] msgmni has been set to 243
> > [    0.099708] request_module: runaway loop modprobe char-major-5-1
> > [    0.100482] request_module: runaway loop modprobe char-major-5-1
> > [    0.101851] request_module: runaway loop modprobe char-major-5-1
> > [    0.102534] request_module: runaway loop modprobe char-major-5-1
> > [    0.106311] request_module: runaway loop modprobe char-major-5-1
> > (hangs)
> > 
> > after reading http://lwn.net/Articles/310472/ and comparing the output after 
> > msgmni of a working kernel on a other machine i found the config option change 
> > which breaks it:
> 
> Hi, you may want this:
> 31d1d48e199e99077fb30f6fb9a793be7bec756f
> 
> Adding stable to consider it for inclusion in .35 stable too.

Now queued up for the next .35-stable kernel release.

thanks,

greg k-h
