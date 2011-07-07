Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab1GGVNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 17:13:44 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23586 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1GGVNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 17:13:43 -0400
Date: Thu, 7 Jul 2011 14:12:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] scsi fixes for 3.0-rc5
Message-Id: <20110707141258.786bb7f9.randy.dunlap@oracle.com>
In-Reply-To: <20110704165535.ce364909.randy.dunlap@oracle.com>
References: <1309813216.2606.32.camel@mulgrave>
	<20110704165535.ce364909.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E162164.006B:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jul 2011 16:55:35 -0700 Randy Dunlap wrote:

> On Mon, 04 Jul 2011 16:00:16 -0500 James Bottomley wrote:
> 
> > This is a couple of driver fixes and the addition of the isci intel SAS
> > driver under the new driver merge exception.  The isci tree is cleanly
> > separated with everything under drivers/scsi/isci (plus the
> > Makefile/Kconfig plumbing and one firmware file under firmware/isci).
> > The driver itself weighs in at around 23k lines, which is on the heavy
> > side, but Christoph Hellwig and I think it's ready enough to accept now
> > so that we have a working driver by the time the motherboards ship
> > (estimated to be in the 3.0 release timeframe).
> > 
> > The patch is available here:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> > 
> > The shortlog for just the driver fixes (lest they get lost in the flood) is:
> > 
> > Brian King (1):
> >       ibmvfc: Fix Virtual I/O failover hang
> > 
> > Stephen M. Cameron (2):
> >       hpsa: fix potential overrun while memcpy'ing sense data
> >       hpsa: fix dma unmap error in hpsa_passthru_ioctl
> 
> Hi James,
> 
> Did you do anything with these 2 scsi section mismatch patches from June 21?
> I don't see them in any of your scsi git trees, although I could have
> missed them.
> 
> Subject: [PATCH] scsi: fix NCR_Q720 section mismatch warning
> http://marc.info/?l=linux-scsi&m=130868730409600&w=2
> 
> Subject: [PATCH] scsi: fix sim710 section mismatch warnings
> http://marc.info/?l=linux-scsi&m=130868736409676&w=2

p i n g

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
