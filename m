Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab0K3VoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:44:13 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:45664 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab0K3VoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:44:12 -0500
Date: Tue, 30 Nov 2010 13:44:08 -0800
From: Andres Salomon <dilinger@queued.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cs5535-mfd: fix warning on x86-64
Message-ID: <20101130134408.22d8127b@queued.net>
In-Reply-To: <20101130102257.008fb652.randy.dunlap@oracle.com>
References: <20101129115257.9a78ad14.sfr@canb.auug.org.au>
	<20101129204410.339805ef@queued.net>
	<20101130102257.008fb652.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 10:22:57 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Mon, 29 Nov 2010 20:44:10 -0800 Andres Salomon wrote:
> 
> > On Mon, 29 Nov 2010 11:52:57 +1100
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > Hi Samuel,
> > > 
> > > After merging the mfd tree, today's linux-next build (x86_64
> > > allmodconfig) produced this warning:
> > > 
> > > drivers/mfd/cs5535-mfd.c: In function 'cs5535_mfd_probe':
> > > drivers/mfd/cs5535-mfd.c:106: warning: format '%d' expects type
> > > 'int', but argument 3 has type 'long unsigned int'
> > > 
> > 
> > Ick, ARRAY_SIZE is unsigned int on x86, unsigned long on x86-64.
> > The patch below fixes this.
> > 
> 
> No, it's a sizeof(), so it should be printed with %zd.
> That works on x86_64 or i386.
> 

Thanks Randy.  I'll provide a new patch.
