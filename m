Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab1ELUkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:40:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:46407 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757573Ab1ELUkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:40:22 -0400
Date: Thu, 12 May 2011 13:40:09 -0700
From: Greg KH <gregkh@suse.de>
To: =?iso-8859-1?Q?St=E9phane?= Pajot <pajot.stephane@gmail.com>
Cc: arun.thomas@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: comedi: fix tabulation and over 80 chars
 issues in amplc_pci224.c This is a patch to the amplc_pci224.c file that
 fixes up tabulation style errors and over 80 chars warning found by the
 checkpatch.pl tool Signed-off-by: Steph
Message-ID: <20110512204009.GA3735@suse.de>
References: <BANLkTi=1fdP1t0SN0fLEq_Rhx7kJkTVRLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=1fdP1t0SN0fLEq_Rhx7kJkTVRLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 10:03:35PM +0200, Stéphane Pajot wrote:
> My answer in purple :

Purple doesn't show up in plain text email clients :(

> 2011/5/12 Greg KH <gregkh@suse.de>
> 
>     On Thu, May 12, 2011 at 06:44:58PM +0200, Stephane Pajot wrote:
>     > ---
>     >  drivers/staging/comedi/drivers/amplc_pci224.c |   63
>     +++++++++++++------------
>     >  1 files changed, 33 insertions(+), 30 deletions(-)
>     >
>     > diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/
>     staging/comedi/drivers/amplc_pci224.c
>     > index 1b5ba1c..2f61358 100644
>     > --- a/drivers/staging/comedi/drivers/amplc_pci224.c
>     > +++ b/drivers/staging/comedi/drivers/amplc_pci224.c
>     > @@ -52,33 +52,33 @@ Supports:
>     >  Configuration options - PCI224:
>     >    [0] - PCI bus of device (optional).
>     >    [1] - PCI slot of device (optional).
>     > -          If bus/slot is not specified, the first available PCI device
>     > -          will be used.
>     > +     If bus/slot is not specified, the first available PCI device
>     > +     will be used.
> 
>     Why did you change these comment lines ? 
> 
> 
> I change the space by a tabulation. Checkpatch.pl return errors about that
> (maybe it's a mistake...). Question : when checkpatch.pl return this kind of
> error (tabulation, or style in general) do we have to correct it too ?    

Just leave it alone, checkpatch isn't always correct, it's a guideline.

thanks,

greg k-h
