Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab1EFQdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 12:33:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50258 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332Ab1EFQdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 12:33:18 -0400
Subject: Re: [stable] [patch 04/38] [SCSI] put stricter guards on queue
 dead checks
From: James Bottomley <James.Bottomley@suse.de>
To: Greg KH <greg@kroah.com>
Cc: Jim Schutt <jaschut@sandia.gov>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110506161754.GA31472@kroah.com>
References: <20110506001207.658271797@clark.kroah.org>
	 <4DC40B94.9060903@sandia.gov>  <20110506161754.GA31472@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 11:33:11 -0500
Message-ID: <1304699591.12427.7.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 09:17 -0700, Greg KH wrote:
> On Fri, May 06, 2011 at 08:54:12AM -0600, Jim Schutt wrote:
> > Hi Greg,
> > 
> > Greg KH wrote:
> > >2.6.38-stable review patch.  If anyone has any objections, please let us know.
> > 
> > You probably don't want to add this patch to stable kernels
> > until commit c055f5b2614b4f from
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6
> > shows up in Linus' tree.
> > 
> > See details in http://www.spinics.net/lists/kernel/msg1181665.html.
> 
> James, do you agree with this?

Yes ... let me push to linus today ... it's been in -next for long
enough.

James


