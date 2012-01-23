Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab2AWWfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 17:35:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab2AWWfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 17:35:47 -0500
Date: Mon, 23 Jan 2012 14:35:08 -0800
From: Greg KH <gregkh@suse.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        dave@linux.vnet.ibm.com, cascardo@holoscopio.com,
        sjenning@linux.vnet.ibm.com
Subject: Re: [PATCH] zcache fix for 3.3-rc1.
Message-ID: <20120123223508.GA10729@suse.de>
References: <1327355540-30681-1-git-send-email-konrad.wilk@oracle.com>
 <20120123221155.GA10265@suse.de>
 <20120123222238.GB31852@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123222238.GB31852@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 05:22:38PM -0500, Konrad Rzeszutek Wilk wrote:
> On Mon, Jan 23, 2012 at 02:11:55PM -0800, Greg KH wrote:
> > On Mon, Jan 23, 2012 at 04:52:19PM -0500, Konrad Rzeszutek Wilk wrote:
> > > Hey Greg,
> > > 
> > > I posted this patch some time ago  [https://lkml.org/lkml/2012/1/13/253]
> > > but I am not seeing it in you tree.
> > 
> > Did you copy me on it?  I don't see it anywhere in my to-apply queues.
> 
> Ugh, I did not - I seemed to have forgotten to CC you and had assumed you
> would be omnipresent and would magically pick it up. Sorry about that mishap.

Hm, I must be slipping, I should have caught that :)

> > > Was wondering if you could stick this patch in your tree? It fixes
> > > a performance regressions which is quite noticable in small memory systems
> > > where a 'swapoff' ends up taking more than it should.
> > 
> > So this is needed for 3.3?  How about older kernels?  3.2?  3.0?
> 
> That would be splendid if you could stick it on the stable tree :-)

Which one(s)?

thanks,

greg k-h
