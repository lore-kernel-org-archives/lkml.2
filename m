Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab1K1FH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 00:07:57 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57930 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981Ab1K1FHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 00:07:55 -0500
X-Sasl-enc: VYTwLBa/ygD9j/ftiA1UXlxQcWPbELnIN4ao1GXSH7vz 1322456874
Date: Mon, 28 Nov 2011 14:07:49 +0900
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Airlie <airlied@linux.ie>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Rob Clark <rob.clark@linaro.org>
Subject: Re: linux-next: build failure after merge of the drm tree
Message-ID: <20111128050749.GC9372@kroah.com>
References: <20111116113007.5656a7b4823ba085a46c57ae@canb.auug.org.au>
 <20111125124913.405fc8360a185f3116adb5ec@canb.auug.org.au>
 <20111125103011.18e167cd@lxorguk.ukuu.org.uk>
 <20111128135204.33bb929d7495d7830d09dfc3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128135204.33bb929d7495d7830d09dfc3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 01:52:04PM +1100, Stephen Rothwell wrote:
> Hi Alan,
> 
> On Fri, 25 Nov 2011 10:30:11 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >
> > > Ping?
> > 
> > As I said last time you asked this - the correct merge resolution is to
> > pull the DRM updates and mark the staging GMA500 Kconfig "&& BROKEN". The
> > staging driver is frozen while we merge outside of staging and will not
> > be getting any attention at this point - changes there just mess up the
> > move work which is far more important.
> > 
> > Also nothing in staging should be allowed to hold up real work. The
> > resolution for anything in staging blocking merges is to mark the staging
> > parts && BROKEN IMHO
> 
> Then if you are moving a driver out of staging, you should put a patch in
> your tree to disable it in staging (or remove it in staging) and send
> that patch to Greg as well.

That patch is already in my staging-next tree, so all should be good
now.

Even then, I don't think that broken staging drivers should stop any
other tree from being included, except for the staging tree itself.

thanks,

greg k-h
