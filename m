Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab0EER6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 13:58:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab0EER6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 13:58:45 -0400
Date: Wed, 5 May 2010 10:58:35 -0700
From: Greg KH <gregkh@suse.de>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, devel@driverdev.osuosl.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 4 (staging/dt3155v4l) [PATCH]
Message-ID: <20100505175835.GA18610@suse.de>
References: <20100504162305.4a07a18a.sfr@canb.auug.org.au>
 <20100504191223.GB13208@suse.de>
 <4BE07890.8060707@oracle.com>
 <201005052031.39043.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005052031.39043.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 08:31:38PM +0300, Marin Mitov wrote:
> On Tuesday 04 May 2010 10:42:08 pm Randy Dunlap wrote:
> > On 05/04/10 12:12, Greg KH wrote:
> > > On Tue, May 04, 2010 at 11:36:04AM -0700, Randy Dunlap wrote:
> > >> On Tue, 4 May 2010 16:23:05 +1000 Stephen Rothwell wrote:
> > >>
> > >>> Hi all,
> > >>>
> > >>> Changes since 20100503:
> > >>
> > >>
> > >> drivers/staging/dt3155v4l/dt3155v4l.c:73: error: implicit declaration of function 'udelay'
> > >> drivers/staging/dt3155v4l/dt3155v4l.c:616: warning: assignment from incompatible pointer type
> > >> drivers/staging/dt3155v4l/dt3155v4l.c:1270: error: implicit declaration of function 'msleep'
> > > 
> > > Ick.  What arch was this?
> > 
> > That is on x86_64.
> > 
> > The config is attached.
> > 
> It's my fault, sorry.
> 
> Here is a patch solving the problem. Compiles with Randy's config, but does not link
> 
> drivers/staging/built-in.o: In function `format_by_fourcc':
> (.text+0x211da): multiple definition of `format_by_fourcc'
> drivers/media/built-in.o:(.text+0x2a744): first defined here
> 
> drivers/media/common/saa7146_video.c:struct saa7146_format* format_by_fourcc(struct saa7146_dev *dev, int fourcc)
> drivers/staging/cx25821/cx25821-video.c:struct cx25821_fmt *format_by_fourcc(unsigned int fourcc)

That's not your driver's problem :)

I've queued up your patch, thanks.

greg k-h
