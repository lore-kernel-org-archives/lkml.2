Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0IBD3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 23:29:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:47117 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab0IBD3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 23:29:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,307,1280732400"; 
   d="scan'208";a="602894167"
From: "Wang, Qi" <qi.wang@intel.com>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>, Greg KH <greg@kroah.com>
CC: "meego-dev@meego.com" <meego-dev@meego.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Greg KH <gregkh@suse.de>
Date: Thu, 2 Sep 2010 11:29:00 +0800
Subject: RE: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Thread-Topic: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Thread-Index: ActKTqnSoS/IkgLTSJ6tJ/VMF3hecQAADExA
Message-ID: <D5AB6E638E5A3E4B8F4406B113A5A19A2A56E53B@shsmsx501.ccr.corp.intel.com>
References: <4C7E441E.4090006@dsn.okisemi.com>
 <20100902010236.GA21782@kroah.com>
 <000601cb4a47$b1a7d1d0$66f8800a@maildom.okisemi.com>
 <20100902032227.GA27463@suse.de>
In-Reply-To: <20100902032227.GA27463@suse.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o823TV1S011640

Hi Ohtake-san,

Would you please sync this patch with our source-forge also?

Hi Greg,

Thank you for your help.

Best Regards,
Qi.

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Thursday, September 02, 2010 11:22 AM
> To: Masayuki Ohtake
> Cc: Greg KH; meego-dev@meego.com; LKML; Wang, Yong Y; Wang, Qi; Khor,
> Andrew Chih Howe; arjan@linux.intel.com; alan@linux.intel.com; Foster,
> Margie; Tomoya MORINAGA
> Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
> 
> On Thu, Sep 02, 2010 at 11:36:45AM +0900, Masayuki Ohtake wrote:
> > Hi Greg,
> >
> > > Nope, I still get a warning with this patch, but I'll go fix it up:
> > Sorry for our warning.
> > We tested with kernel-2.6.35.3.
> > We will modify so that warning becomes to disappear soon.
> 
> I already fixed this up now.  The issue was that you were not using %p
> to print out a pointer and you were trying to use an int instead of a
> ssize_t for the pci rom stuff.  All of that shows up when building on
> x86-64.
> 
> I've commited the fix to my tree, you should have been copied on it
> already.
> 
> thanks,
> 
> greg k-h
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
