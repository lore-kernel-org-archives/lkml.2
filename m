Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1JGRR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 13:17:58 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37396 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751573Ab1JGRR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 13:17:57 -0400
X-Sasl-enc: 31WE9b194LxuiVrSjd6jJYAuAlXCYoLO7DdG8TaEvmlw 1318007876
Date: Fri, 7 Oct 2011 10:01:23 -0700
From: Greg KH <greg@kroah.com>
To: Valdis.Kletnieks@vt.edu
Cc: Jiri Kosina <jkosina@suse.cz>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: virtualbox tainting.
Message-ID: <20111007170123.GA2121@kroah.com>
References: <20111006190526.GA13883@redhat.com>
 <20111006194432.GA21642@kroah.com>
 <20111006195007.GA24900@redhat.com>
 <20111006195824.GA22033@kroah.com>
 <20111006200440.GB25681@redhat.com>
 <alpine.LRH.2.00.1110070959470.14853@twin.jikos.cz>
 <14168.1318003445@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14168.1318003445@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 12:04:05PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 07 Oct 2011 10:01:32 +0200, Jiri Kosina said:
> > On Thu, 6 Oct 2011, Dave Jones wrote:
> 
> > > what stops an out of tree module from setting that flag ?
> > 
> > What stops virtualbox developers from renaming the module in every 
> > release? That's the same story.
> > 
> > The only fool-proof way of doing is indeed is the GPG-signing thing.
> 
> It would also be a second in-tree user for the kernel MPI library code that
> somebody posted recently... Just sayin' ;)

Ah, that is a good idea as some systems do want to gpg sign kernel
modules, I would love it if someone dug up the Red Hat patches, ported
it to the in-kernel mpi library (which I think will be in 3.2) and got
it merged.

Actually, anyone have any pointers to the Red Hat patch, I might
consider doing this myself as I wrote the first gpg signed kernel code
years ago and I would like to see this finally merged.

greg k-h
