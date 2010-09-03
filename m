Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0ICASG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 20:18:06 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:19742 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349Ab0ICASE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 20:18:04 -0400
Message-ID: <000c01cb4afd$78e18ce0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Greg KH" <gregkh@suse.de>
Cc: "Greg KH" <greg@kroah.com>, <meego-dev@meego.com>,
        "LKML" <linux-kernel@vger.kernel.org>, <yong.y.wang@intel.com>,
        <qi.wang@intel.com>, <andrew.chih.howe.khor@intel.com>,
        <arjan@linux.intel.com>, <alan@linux.intel.com>,
        <margie.foster@intel.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>
References: <4C7E441E.4090006@dsn.okisemi.com> <20100902010236.GA21782@kroah.com> <000601cb4a47$b1a7d1d0$66f8800a@maildom.okisemi.com> <20100902032227.GA27463@suse.de> <002201cb4a69$6ba15db0$66f8800a@maildom.okisemi.com> <20100902131833.GA1021@suse.de>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Date: Fri, 3 Sep 2010 09:17:58 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I understand.
Since we have only 32-bit kernel, we couldn't see the WARNINGs.

Thanks, Ohtake(OKISemi)

----- Original Message ----- 
From: "Greg KH" <gregkh@suse.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Greg KH" <greg@kroah.com>; <meego-dev@meego.com>; "LKML" <linux-kernel@vger.kernel.org>; <yong.y.wang@intel.com>;
<qi.wang@intel.com>; <andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <alan@linux.intel.com>;
<margie.foster@intel.com>; "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>
Sent: Thursday, September 02, 2010 10:18 PM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35


> On Thu, Sep 02, 2010 at 03:38:11PM +0900, Masayuki Ohtake wrote:
> > Hi Greg,
> >
> > > Nope, I still get a warning with this patch, but I'll go fix it up:
> >
> > To see your indicated warning information,
> > I have tried to build the following(latest) version with our phub patch.
> >   - linux-2.6.35.4
> >   - linux-2.6.35.y
> >
> > But we can't see the warning(No warning No error).
> > How can we see the warning ?
>
> Build it on a x86-64 kernel.  The issue was the 64bit size of a pointer
> and the ssize_t variable.  My fix solved these issues for both the 32
> and 64bit kernels.
>
> thanks,
>
> greg k-h
>


