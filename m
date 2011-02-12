Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab1BLR3h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:29:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49170 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1BLR3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:29:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] mmc: add ricoh e823 pci id
Date: Sat, 12 Feb 2011 18:29:26 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: Manoj Iyer <manoj.iyer@canonical.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
References: <1297463131-3557-1-git-send-email-manoj.iyer@canonical.com> <1297463131-3557-2-git-send-email-manoj.iyer@canonical.com> <20110211224234.GA1958@void.printf.net>
In-Reply-To: <20110211224234.GA1958@void.printf.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102121829.26608.arnd@arndb.de>
X-Provags-ID: V02:K0:g9PnZOTlc8JBudcNat4yhaXChPLSgi2Stq7mDblJHAl
 cKq4Tu3JF7vHm3yaD3+6fiitOiumoGGwhSpDStbofJphZfsfKp
 hfqhC9vPh4Yp39qHLVdQKjj3ErKpMGr7OHa5IhPjrB2IWTY1Bm
 p0LdAYpW4R5Vc4ZIp7hHSEbj1mTWBGW9sJm83GVQ1CNgJG6Q4a
 EG+8SQV0BctIl/GChUVig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 February 2011 23:42:34 Chris Ball wrote:
> >  
> >       {
> > +             .vendor         = PCI_VENDOR_ID_RICOH,
> > +             .device         = 0xe823,
> > +             .subvendor      = PCI_ANY_ID,
> > +             .subdevice      = PCI_ANY_ID,
> > +             .driver_data    = (kernel_ulong_t)&sdhci_ricoh_mmc,
> > +     },
> > +
> > +     {
> >               .vendor         = PCI_VENDOR_ID_ENE,
> >               .device         = PCI_DEVICE_ID_ENE_CB712_SD,
> >               .subvendor      = PCI_ANY_ID,
> 
> Thanks, pushed to mmc-next for .39.

Wouldn't this be a candidate for -stable as well?

	Arnd
