Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab0HTGxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 02:53:38 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:14219 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076Ab0HTGxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 02:53:37 -0400
Message-ID: <001601cb4034$69507a30$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Greg KH" <gregkh@suse.de>
Cc: <meego-dev@meego.com>, "LKML" <linux-kernel@vger.kernel.org>,
        <yong.y.wang@intel.com>, <qi.wang@intel.com>,
        <andrew.chih.howe.khor@intel.com>, <arjan@linux.intel.com>,
        <alan@linux.intel.com>, <margie.foster@intel.com>
References: <4C6BA385.80409@dsn.okisemi.com> <20100818131401.GA5861@suse.de> <000401cb3f67$9936adf0$66f8800a@maildom.okisemi.com> <20100819151712.GC2562@suse.de>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Date: Fri, 20 Aug 2010 15:53:33 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
x-mimeole: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Greg KH" <gregkh@suse.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: <meego-dev@meego.com>; "LKML" <linux-kernel@vger.kernel.org>; <yong.y.wang@intel.com>; <qi.wang@intel.com>;
<andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <alan@linux.intel.com>; <margie.foster@intel.com>
Sent: Friday, August 20, 2010 12:17 AM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35


> On Thu, Aug 19, 2010 at 03:27:23PM +0900, Masayuki Ohtake wrote:
> > Hi Greg,
> >
> > Thank you for your comments.
> > > > +#define MODULE_NAME "pch_phub"
> > >
> > > This isn't needed, right?  The kernel provides this to you in the build
> > > service automatically.
> >
> > I can't understand above enough.
> > Is the above mean  like below ?
> >
> > * Delete the following line.
> > > > +#define MODULE_NAME "pch_phub"
> >
> >  * Modify the following line(Use "pch_phub" directly)
> > > > + ret = pci_request_regions(pdev, "pch_phub");
>
> No, use the variable that the build system provides to you,
> KBUILD_MODNAME

I understand.

Thanks, Ohtake(OKISEMI)

>
> thanks,
>
> greg k-h
>


