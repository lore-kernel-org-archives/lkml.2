Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091Ab1LHUHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 15:07:18 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47741 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708Ab1LHUHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 15:07:14 -0500
X-Sasl-enc: MbGJ8Q2d9kGbGADiDyR8QB0XCByYGTDp5UDnZgeByRuA 1323374833
Date: Thu, 8 Dec 2011 11:25:33 -0800
From: Greg KH <greg@kroah.com>
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: vt6655: card.c, srom.c, vntwifi.c: Code
 cleanup
Message-ID: <20111208192533.GA19310@kroah.com>
References: <1322855892-6400-1-git-send-email-marcos.mage@gmail.com>
 <20111203083215.GF3195@mwanda>
 <alpine.LNX.2.00.1112042000070.5963@cactuar.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1112042000070.5963@cactuar.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 04, 2011 at 08:01:39PM -0200, Marcos Paulo de Souza wrote:
> On Sat, 3 Dec 2011, Dan Carpenter wrote:
> >On Fri, Dec 02, 2011 at 07:58:12PM +0000, Marcos Paulo de Souza wrote:
> >>This patch removes commented code, useless comments, blank lines and fix
> >>coding style of the headers of functions.
> >>
> >>Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
> >>Cc: Greg Kroah-Hartman <gregkh@suse.de>
> >>Cc: devel@driverdev.osuosl.org
> >>---
> >> /*
> >>- * Description: Test if bits off in eeprom
> >>- *
> >>- * Parameters:
> >>- *  In:
> >>- *      dwIoBase        - I/O base address
> >>- *      byContntOffset  - address of EEPROM
> >>- *      byTestBits      - bits to test
> >>- *  Out:
> >>- *      none
> >>- *
> >>- * Return Value: true if all test bits off; otherwise false
> >>- *
> >>+ * Test if bits off in eeprom
> >>  */
> >
> >Some of these seems sort of useful.  It might be better to change
> >them to doc-book format instead of deleting them:
> >
> >/**
> >* SROMbIsRegBitsOff() - Test if bits off in eeprom
> >* @dwIoBase:       I/O base address
> >* @byContntOffset: Address of EEPROM
> >* @byTestBits:     Bits to test
> >*
> >* Returns true if all test bits off; otherwise false.
> >*/
> >
> >There is a howto in Documentation/kernel-doc-nano-HOWTO.txt.
> 
> Thanks for the suggestion Dan. I will do it for these 3 patches.
> 
> Greg, please delte this patches, I will sent them again.

Ugh, "which" patches are you referring to?

I see lots here from you, with different back-and-forth from Dan, and I
don't really see an easy way to tell which thread from which, given that
you didn't thread the patches using git-send-email.

So, I've dropped all patches from you from my patch queue, can you
please resend the ones that I am supposed to apply that have been
reviewed by Dan as being acceptable?

thanks,

greg k-h
