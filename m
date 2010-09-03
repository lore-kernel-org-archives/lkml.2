Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0ICBOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:14:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:17207 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab0ICBOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:14:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,310,1280732400"; 
   d="scan'208";a="603267101"
From: "Wang, Qi" <qi.wang@intel.com>
To: Greg KH <gregkh@suse.de>
CC: Greg KH <greg@kroah.com>, "meego-dev@meego.com" <meego-dev@meego.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Date: Fri, 3 Sep 2010 09:13:43 +0800
Subject: RE: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Thread-Topic: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Thread-Index: ActKoWLFwdXNfO+OSYKrGDRT+gq6rAAY60lA
Message-ID: <D5AB6E638E5A3E4B8F4406B113A5A19A2A56E877@shsmsx501.ccr.corp.intel.com>
References: <4C7E441E.4090006@dsn.okisemi.com>
 <20100902010236.GA21782@kroah.com>
 <000601cb4a47$b1a7d1d0$66f8800a@maildom.okisemi.com>
 <20100902032227.GA27463@suse.de>
 <D5AB6E638E5A3E4B8F4406B113A5A19A2A56E53B@shsmsx501.ccr.corp.intel.com>
 <002b01cb4a6a$3ae499c0$66f8800a@maildom.okisemi.com>
 <20100902131913.GB1021@suse.de>
In-Reply-To: <20100902131913.GB1021@suse.de>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o831EVXl018091

Hi Greg KH,

When all the drivers are accepted by the upstream, our source-forge is useless. Currently it's a temporary site for us to smoke test the driver quality.

Best Regards,
Qi.

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Thursday, September 02, 2010 9:19 PM
> To: Masayuki Ohtake
> Cc: Wang, Qi; Greg KH; meego-dev@meego.com; LKML; Wang, Yong Y; Khor,
> Andrew Chih Howe; arjan@linux.intel.com; alan@linux.intel.com; Foster,
> Margie; Tomoya MORINAGA
> Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
> 
> On Thu, Sep 02, 2010 at 03:44:00PM +0900, Masayuki Ohtake wrote:
> > Hi Qi-san
> >
> > I will sync this phub patch to source-forge by today.
> 
> You are going to delete this version when the driver is merged into the
> kernel tree, right?  Please don't try to maintain the code external to
> the kernel, that never works properly.
> 
> thanks,
> 
> greg k-h
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
