Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab0ICAWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 20:22:17 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:31737 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968Ab0ICAWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 20:22:16 -0400
Message-ID: <001101cb4afe$0f729ff0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Greg KH" <gregkh@suse.de>
Cc: "Wang, Qi" <qi.wang@intel.com>, "Greg KH" <greg@kroah.com>,
        <meego-dev@meego.com>, "LKML" <linux-kernel@vger.kernel.org>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
        <arjan@linux.intel.com>, <alan@linux.intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>
References: <4C7E441E.4090006@dsn.okisemi.com> <20100902010236.GA21782@kroah.com> <000601cb4a47$b1a7d1d0$66f8800a@maildom.okisemi.com> <20100902032227.GA27463@suse.de> <D5AB6E638E5A3E4B8F4406B113A5A19A2A56E53B@shsmsx501.ccr.corp.intel.com> <002b01cb4a6a$3ae499c0$66f8800a@maildom.okisemi.com> <20100902131913.GB1021@suse.de>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Date: Fri, 3 Sep 2010 09:22:12 +0900
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

We are going to maintain our patch using kernel-tree's
after merging kernel-tree.

Thanks, Ohtake(OKISemi)
----- Original Message ----- 
From: "Greg KH" <gregkh@suse.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Wang, Qi" <qi.wang@intel.com>; "Greg KH" <greg@kroah.com>; <meego-dev@meego.com>; "LKML"
<linux-kernel@vger.kernel.org>; "Wang, Yong Y" <yong.y.wang@intel.com>; "Khor, Andrew Chih Howe"
<andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <alan@linux.intel.com>; "Foster, Margie"
<margie.foster@intel.com>; "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>
Sent: Thursday, September 02, 2010 10:19 PM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35


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
>


