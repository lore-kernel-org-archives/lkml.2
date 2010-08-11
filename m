Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0HKPS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 11:18:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab0HKPS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 11:18:56 -0400
Date: Wed, 11 Aug 2010 08:15:10 -0700
From: Greg KH <gregkh@suse.de>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, LKML <linux-kernel@vger.kernel.org>,
        qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, arjan@linux.intel.com
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to
 2.6.35
Message-ID: <20100811151510.GB9180@suse.de>
References: <4C612AA4.5040100@dsn.okisemi.com>
 <20100810171343.GE21220@suse.de>
 <002601cb3926$edaf24d0$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002601cb3926$edaf24d0$66f8800a@maildom.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 04:29:25PM +0900, Masayuki Ohtake wrote:
> Hi Greg,
> 
> > Do they all have to be ioctls?  What exactly are they doing?
> I think using ioctl is common for this patch.

"Common" is not ok, right?

> Do you think that using ioctl is NOT appropriate for this patch?

Yes.

> Let me know your intension in more detail.

Please express yours.  Why do you feel you need these to be ioctls?
What exactly are they doing?  Where is the documentation for them all?

> > And are they 32/64bit safe?
> Only 32bit support.

That's an obvious problem that needs to be resolved, right?

thanks,

greg k-h
