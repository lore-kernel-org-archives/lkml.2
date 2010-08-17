Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab0HQNZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:25:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:39020 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab0HQNZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:25:05 -0400
Date: Tue, 17 Aug 2010 06:07:40 -0700
From: Greg KH <gregkh@suse.de>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, LKML <linux-kernel@vger.kernel.org>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
        arjan@linux.intel.com, "Wang, Qi" <qi.wang@intel.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to
 2.6.35
Message-ID: <20100817130740.GA24564@suse.de>
References: <4C612AA4.5040100@dsn.okisemi.com>
 <20100810171343.GE21220@suse.de>
 <002601cb3926$edaf24d0$66f8800a@maildom.okisemi.com>
 <20100811151510.GB9180@suse.de>
 <D5AB6E638E5A3E4B8F4406B113A5A19A28EA26B2@shsmsx501.ccr.corp.intel.com>
 <20100812020027.GA14121@suse.de>
 <D5AB6E638E5A3E4B8F4406B113A5A19A28EA272F@shsmsx501.ccr.corp.intel.com>
 <001001cb3ddb$9929d9a0$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001001cb3ddb$9929d9a0$66f8800a@maildom.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 04:12:45PM +0900, Masayuki Ohtake wrote:
> > > > > On Wed, Aug 11, 2010 at 04:29:25PM +0900, Masayuki Ohtake wrote:
> > > > > > Hi Greg,
> > > > > >
> > > > > > > Do they all have to be ioctls?  What exactly are they doing?
> > > > > > I think using ioctl is common for this patch.
> > > > >
> > > > > "Common" is not ok, right?
> > > > >
> > > > > > Do you think that using ioctl is NOT appropriate for this patch?
> > > > >
> > > > > Yes.
> > > > >
> > > > > > Let me know your intension in more detail.
> > > > >
> > > > > Please express yours.  Why do you feel you need these to be ioctls?
> > > > > What exactly are they doing?  Where is the documentation for them all?
> > >
> > > You forgot to answer this.
> > Ohtake-san,
> >
> > Please answer this question asap.
> 
> Intel Topcliff IEEE1588 device driver API is developed according to Intel
> Tolapai 1588 device driver.
> Both APIs are the same.

That _still_ did not answer the questions.  Please answer them.

greg k-h
