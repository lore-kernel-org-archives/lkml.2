Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab0IBGoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 02:44:06 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:4590 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080Ab0IBGoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 02:44:04 -0400
Message-ID: <002b01cb4a6a$3ae499c0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Wang, Qi" <qi.wang@intel.com>, "Greg KH" <greg@kroah.com>
Cc: <meego-dev@meego.com>, "LKML" <linux-kernel@vger.kernel.org>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
        <arjan@linux.intel.com>, <alan@linux.intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        "Greg KH" <gregkh@suse.de>
References: <4C7E441E.4090006@dsn.okisemi.com> <20100902010236.GA21782@kroah.com> <000601cb4a47$b1a7d1d0$66f8800a@maildom.okisemi.com> <20100902032227.GA27463@suse.de> <D5AB6E638E5A3E4B8F4406B113A5A19A2A56E53B@shsmsx501.ccr.corp.intel.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Date: Thu, 2 Sep 2010 15:44:00 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Qi-san

I will sync this phub patch to source-forge by today.

Thanks, Ohtake(OKISemi)
----- Original Message ----- 
From: "Wang, Qi" <qi.wang@intel.com>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>; "Greg KH" <greg@kroah.com>
Cc: <meego-dev@meego.com>; "LKML" <linux-kernel@vger.kernel.org>; "Wang, Yong Y" <yong.y.wang@intel.com>; "Khor, Andrew
Chih Howe" <andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <alan@linux.intel.com>; "Foster, Margie"
<margie.foster@intel.com>; "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>; "Greg KH" <gregkh@suse.de>
Sent: Thursday, September 02, 2010 12:29 PM
Subject: RE: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35


> Hi Ohtake-san,
>
> Would you please sync this patch with our source-forge also?
>
> Hi Greg,
>
> Thank you for your help.
>
> Best Regards,
> Qi.
>
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@suse.de]
> > Sent: Thursday, September 02, 2010 11:22 AM
> > To: Masayuki Ohtake
> > Cc: Greg KH; meego-dev@meego.com; LKML; Wang, Yong Y; Wang, Qi; Khor,
> > Andrew Chih Howe; arjan@linux.intel.com; alan@linux.intel.com; Foster,
> > Margie; Tomoya MORINAGA
> > Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
> >
> > On Thu, Sep 02, 2010 at 11:36:45AM +0900, Masayuki Ohtake wrote:
> > > Hi Greg,
> > >
> > > > Nope, I still get a warning with this patch, but I'll go fix it up:
> > > Sorry for our warning.
> > > We tested with kernel-2.6.35.3.
> > > We will modify so that warning becomes to disappear soon.
> >
> > I already fixed this up now.  The issue was that you were not using %p
> > to print out a pointer and you were trying to use an int instead of a
> > ssize_t for the pci rom stuff.  All of that shows up when building on
> > x86-64.
> >
> > I've commited the fix to my tree, you should have been copied on it
> > already.
> >
> > thanks,
> >
> > greg k-h
>


