Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0EMRJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:09:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60878 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750914Ab0EMRJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:09:23 -0400
Date: Thu, 13 May 2010 18:13:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>, jeff@garzik.org, linux-ide@vger.kernel.org,
       jens.axboe@oracle.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk
Subject: Re: [PATCHSET] libata: implement ->set_capacity()
Message-ID: <20100513181300.64be595a@lxorguk.ukuu.org.uk>
In-Reply-To: <1273768687.4353.235.camel@mulgrave.site>
References: <1273766206-17402-1-git-send-email-tj@kernel.org>
	<1273766778.4353.200.camel@mulgrave.site>
	<4BEC272E.10508@kernel.org>
	<1273768687.4353.235.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 11:38:07 -0500
James Bottomley <James.Bottomley@suse.de> wrote:

> On Thu, 2010-05-13 at 18:22 +0200, Tejun Heo wrote:
> > > Instead of just saying unlock the HPA and show me the new capacity
> > > (with a rescan), you have to echo the right number of sectors to the
> > > set_capacity variable.  Isn't a hpa_unlock libata specific attribute
> > > better (you could even call BLKRRPART from the user context of the
> > > write)?
> > 
> > Hmmm... I lost you.  What are you talking about?
> 
> Instead of making this a block sysfs attribute, since HPA is SATA only,
> why not make it a libata attribute for the disk?

HPA is both PATA and SATA (and USB SCSI pass through ATA over SCSI etc
with some of the more functional USB/ATA bridges.

