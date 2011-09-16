Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab1IPSkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:40:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab1IPSkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:40:05 -0400
Date: Fri, 16 Sep 2011 20:39:21 +0200
From: Greg KH <gregkh@suse.de>
To: Josh Boyer <jwboyer@redhat.com>
Cc: andi@firstfloor.org, willy@meta-x.org, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org
Subject: Re: stable patch queues and submission
Message-ID: <20110916183921.GB16415@suse.de>
References: <20110916181307.GW10700@zod.bos.redhat.com>
 <20110916182350.GA7315@suse.de>
 <20110916183113.GY10700@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110916183113.GY10700@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 02:31:13PM -0400, Josh Boyer wrote:
> On Fri, Sep 16, 2011 at 08:23:50PM +0200, Greg KH wrote:
> > > Hi All,
> > > 
> > > With kernel.org being down, the stable@kernel.org list is no longer
> > > working.  This leaves me wondering if we should send patches directly to
> > > the various stable tree maintainers with [stable] in the prefix and
> > > linux-kernel CC'd, or if the stable queues are even being maintained
> > > during the outage.
> > 
> > No, please do not, unless you need something "special", and even then,
> > please cc: lkml and the developers so it's not lost.
> 
> Would "special" include patches that are backported for longterm
> releases?

Yes.

greg k-h
