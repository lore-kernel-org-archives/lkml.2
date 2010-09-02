Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab0IBCgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 22:36:51 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:11726 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297Ab0IBCgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 22:36:50 -0400
Message-ID: <000601cb4a47$b1a7d1d0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Greg KH" <greg@kroah.com>
Cc: <meego-dev@meego.com>, "LKML" <linux-kernel@vger.kernel.org>,
        <gregkh@suse.de>, <yong.y.wang@intel.com>, <qi.wang@intel.com>,
        <andrew.chih.howe.khor@intel.com>, <arjan@linux.intel.com>,
        <alan@linux.intel.com>, <margie.foster@intel.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>
References: <4C7E441E.4090006@dsn.okisemi.com> <20100902010236.GA21782@kroah.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Date: Thu, 2 Sep 2010 11:36:45 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> Nope, I still get a warning with this patch, but I'll go fix it up:
Sorry for our warning.
We tested with kernel-2.6.35.3.
We will modify so that warning becomes to disappear soon.

Thanks, Ohtake(OKISemi)
----- Original Message ----- 
From: "Greg KH" <greg@kroah.com>
To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
Cc: <meego-dev@meego.com>; "LKML" <linux-kernel@vger.kernel.org>; <gregkh@suse.de>; <yong.y.wang@intel.com>;
<qi.wang@intel.com>; <andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <alan@linux.intel.com>;
<margie.foster@intel.com>; "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>
Sent: Thursday, September 02, 2010 10:02 AM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35


> On Wed, Sep 01, 2010 at 09:16:30PM +0900, Masayuki Ohtak wrote:
> > Hi Greg,
> >
> > Sorry, we have modified again, for a bug(illegal return code) and
> > WARNING for building with the latest kernel.
>
> Nope, I still get a warning with this patch, but I'll go fix it up:
>   CC [M]  drivers/misc/pch_phub.o
> drivers/misc/pch_phub.c: In function ‘pch_phub_probe’:
> drivers/misc/pch_phub.c:582:334: warning: cast from pointer to integer of different size
> drivers/misc/pch_phub.c:585:2: warning: passing argument 2 of ‘pci_map_rom’ from incompatible pointer type
> include/linux/pci.h:803:43: note: expected ‘size_t *’ but argument is of type ‘unsigned int *’
> drivers/misc/pch_phub.c:592:346: warning: cast from pointer to integer of different size
>
> thanks,
>
> greg k-h
>


