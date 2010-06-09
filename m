Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab0FIJxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:53:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47366 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab0FIJx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:53:28 -0400
Date: Wed, 9 Jun 2010 11:53:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alexander Kurz <linux@blala.de>
Cc: Borislav Petkov <bp@amd64.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Alexander Kurz <linux@kbdbabel.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: Re: linux-next: Tree for June 2 (staging/comedi)
Message-ID: <20100609095315.GA19580@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alexander Kurz <linux@blala.de>, Borislav Petkov <bp@amd64.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Alexander Kurz <linux@kbdbabel.org>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de
References: <20100602151439.6de66132.sfr@canb.auug.org.au>
 <20100602100735.0812c063.randy.dunlap@oracle.com>
 <20100603091555.GA25287@aftab>
 <alpine.DEB.1.10.1006052043140.21893@vs81.sauer-cs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1006052043140.21893@vs81.sauer-cs.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Kurz <linux@blala.de>
Date: Sat, Jun 05, 2010 at 08:50:57PM +0400

> Hi,
> could you please repeat the test on 2.6.35-rc1-git3 or later
> 
> On Thu, 3 Jun 2010, Borislav Petkov wrote:
> > I get a different set of errors with 2.6.35-rc1:
> > 
> > ERROR: "cfc_write_array_to_buffer" [drivers/staging/comedi/drivers/usbduxfast.ko] undefined!
> > ERROR: "cfc_write_array_to_buffer" [drivers/staging/comedi/drivers/comedi_test.ko] undefined!
> was caused by
> > CONFIG_COMEDI_FC=y
> and is fixed in 824196248c1f28aa7d151fd5b11d76182c751f19
> by adding COMEDI_FC depends on COMEDI.
> CONFIG_COMEDI_FC=m would be correct.
> 
> > ERROR: "subdev_8255_cleanup" [drivers/staging/comedi/drivers/das08.ko] undefined!
> > ERROR: "subdev_8255_init" [drivers/staging/comedi/drivers/das08.ko] undefined! 
> CONFIG_COMEDI_8255=m should have been set.
> this should be as well fixed in 824196248c1f28aa7d151fd5b11d76182c751f19 
> by pulling das08 out of the ISA group.

sorry, but I'm away from my testing machines right now and won't be able
to do it until next week. But you could do it yourself in the meantime
using the randconfig I had attached to the previous message.

Thanks.

-- 
Regards/Gruss,
Boris.
