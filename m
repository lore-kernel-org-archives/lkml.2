Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab0IBNSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:18:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:47316 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab0IBNSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 09:18:41 -0400
Date: Thu, 2 Sep 2010 06:18:33 -0700
From: Greg KH <gregkh@suse.de>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Greg KH <greg@kroah.com>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>, yong.y.wang@intel.com,
        qi.wang@intel.com, andrew.chih.howe.khor@intel.com,
        arjan@linux.intel.com, alan@linux.intel.com, margie.foster@intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Message-ID: <20100902131833.GA1021@suse.de>
References: <4C7E441E.4090006@dsn.okisemi.com> <20100902010236.GA21782@kroah.com> <000601cb4a47$b1a7d1d0$66f8800a@maildom.okisemi.com> <20100902032227.GA27463@suse.de> <002201cb4a69$6ba15db0$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002201cb4a69$6ba15db0$66f8800a@maildom.okisemi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 03:38:11PM +0900, Masayuki Ohtake wrote:
> Hi Greg,
> 
> > Nope, I still get a warning with this patch, but I'll go fix it up:
> 
> To see your indicated warning information,
> I have tried to build the following(latest) version with our phub patch.
>   - linux-2.6.35.4
>   - linux-2.6.35.y
> 
> But we can't see the warning(No warning No error).
> How can we see the warning ?

Build it on a x86-64 kernel.  The issue was the 64bit size of a pointer
and the ssize_t variable.  My fix solved these issues for both the 32
and 64bit kernels.

thanks,

greg k-h
