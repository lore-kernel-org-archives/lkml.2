Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab0ERXXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 19:23:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:33006 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab0ERXXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 19:23:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,258,1272870000"; 
   d="scan'208";a="622813627"
Date: Wed, 19 May 2010 01:23:53 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Rabin VINCENT <rabin.vincent@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] mfd: new AB8500 driver
Message-ID: <20100518232352.GB9658@sortiz.org>
References: <1273553131-9312-1-git-send-email-rabin.vincent@stericsson.com>
 <20100516225355.GF3236@sortiz.org>
 <20100517160005.GA32741@bnru02.bnr.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517160005.GA32741@bnru02.bnr.st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rabin,

On Mon, May 17, 2010 at 09:30:06PM +0530, Rabin VINCENT wrote:
> Hi Samuel,
> 
> On Mon, May 17, 2010 at 00:53:55 +0200, Samuel Ortiz wrote:
> > On Tue, May 11, 2010 at 10:15:31AM +0530, Rabin Vincent wrote:
> > > Add a new driver to support the AB8500 Power Management chip, replacing
> > > the current AB4500.  The new driver replaces the old one, instead of an
> > > incremental modification, because this is a substantial overhaul
> > > including:
> > > 
> > >  - Split of the driver into -core and -spi portions, to allow another
> > >    interface layer to be added
> > > 
> > >  - Addition of interrupt support
> > > 
> > >  - Switch to MFD core API for handling subdevices
> > > 
> > >  - Simplification of the APIs to remove a redundant block parameter
> > > 
> > >  - Rename of the APIs and macros from ab4500_* to ab8500_*
> > > 
> > >  - Rename of the files from ab4500* to ab8500*
> > > 
> > > The driver still identifes itself as "ab4500" 
> > The patch looks good, but why not changing that to "ab8500" and integrating
> > the relevant board file changes to this patch ?
> 
> I originally didn't do this because I thought that this would create
> merge conflicts with some code movement in the arm tree, but looks like
> I was wrong -- there won't be conflicts for this change.
> 
> So, the updated patch below also includes the board file change to
> change the driver name from ab4500 to ab8500.  (It also includes a small
> fix to the interrupt handling, found after the previous version was
> sent.)
Thanks, patch applied to my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
