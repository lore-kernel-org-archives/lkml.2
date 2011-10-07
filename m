Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935406Ab1JGRrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 13:47:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab1JGRrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 13:47:05 -0400
Date: Fri, 7 Oct 2011 13:46:37 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Valdis.Kletnieks@vt.edu, Jiri Kosina <jkosina@suse.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>, dhowells@redhat.com
Subject: Re: RFC: virtualbox tainting.
Message-ID: <20111007174637.GA14132@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	Valdis.Kletnieks@vt.edu, Jiri Kosina <jkosina@suse.cz>,
	Linux Kernel <linux-kernel@vger.kernel.org>, dhowells@redhat.com
References: <20111006190526.GA13883@redhat.com>
 <20111006194432.GA21642@kroah.com>
 <20111006195007.GA24900@redhat.com>
 <20111006195824.GA22033@kroah.com>
 <20111006200440.GB25681@redhat.com>
 <alpine.LRH.2.00.1110070959470.14853@twin.jikos.cz>
 <14168.1318003445@turing-police.cc.vt.edu>
 <20111007170123.GA2121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111007170123.GA2121@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 10:01:23AM -0700, Greg Kroah-Hartman wrote:
 
 > > > The only fool-proof way of doing is indeed is the GPG-signing thing.
 > > 
 > > It would also be a second in-tree user for the kernel MPI library code that
 > > somebody posted recently... Just sayin' ;)
 > 
 > Ah, that is a good idea as some systems do want to gpg sign kernel
 > modules, I would love it if someone dug up the Red Hat patches, ported
 > it to the in-kernel mpi library (which I think will be in 3.2) and got
 > it merged.
 > 
 > Actually, anyone have any pointers to the Red Hat patch, I might
 > consider doing this myself as I wrote the first gpg signed kernel code
 > years ago and I would like to see this finally merged.

Dave Howells did the last work on the Red Hat variant iirc.
(added to cc)

	Dave

