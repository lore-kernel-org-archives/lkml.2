Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab2CESer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 13:34:47 -0500
Received: from xes-mad.com ([216.165.139.218]:33068 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757082Ab2CESeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 13:34:46 -0500
Date: Mon, 05 Mar 2012 12:34:31 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter@roeck-us.net>, Peter Tyser <ptyser@xes-inc.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V5 1/3] mfd: Add LPC driver for Intel ICH chipsets
Message-ID: <42bd7bac-6352-451f-b50d-7fdae1f559f3@zimbra>
In-Reply-To: <20120304205259.266bc636@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC15 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Aaron, Grant,
> 
> On Mon, 20 Feb 2012 19:10:41 -0600 (CST), Aaron Sierra wrote:
> > This driver currently creates resources for use by a forthcoming
> > ICH chipset GPIO driver. It could be expanded to create the
> > resources for converting the esb2rom (mtd) and iTCO_wdt (wdt),
> > and potentially more, drivers to use the mfd model.
> > 
> > Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  drivers/mfd/Kconfig         |    9 +
> >  drivers/mfd/Makefile        |    1 +
> >  drivers/mfd/lpc_ich.c       |  717
> >  +++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/lpc_ich.h |   41 +++
> >  4 files changed, 768 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/mfd/lpc_ich.c
> >  create mode 100644 include/linux/mfd/lpc_ich.h
> > (...)
> 
> What's the current state of this patch set ? It works fine for me
> after applying Guenter's fix and passing acpi_enforce_resources=lax
> at boot time. It would be great if these patches could be scheduled
> for merge in kernel 3.4, if they haven't already.
> 
> Thanks,
> --
> Jean Delvare
> 

Jean,
I haven't made any changes other than resolving the issues highlighted by
Guenther two weeks ago. I will apply Grant's changes from today and send
out the latest patchset tomorrow.

-Aaron S.
