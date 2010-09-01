Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab0IAX6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 19:58:34 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:15226 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685Ab0IAX6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 19:58:33 -0400
Message-ID: <002401cb4a31$95116830$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Greg KH" <gregkh@suse.de>
Cc: "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>, <margie.foster@intel.com>,
        <alan@linux.intel.com>, <arjan@linux.intel.com>,
        <andrew.chih.howe.khor@intel.com>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, "LKML" <linux-kernel@vger.kernel.org>,
        <meego-dev@meego.com>
References: <4C7E441E.4090006@dsn.okisemi.com> <20100901230901.GA21326@suse.de>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Date: Thu, 2 Sep 2010 08:58:30 +0900
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

Thank you for your checking.

> Do you want me to queue it up for the .37 kernel merge
> through my tree, or through someone elses?

I want you to queue our phub patch through your tree.

Thanks, Ohtake(OKISemi)
----- Original Message ----- 
From: "Greg KH" <gregkh@suse.de>
To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
Cc: <meego-dev@meego.com>; "LKML" <linux-kernel@vger.kernel.org>; <yong.y.wang@intel.com>; <qi.wang@intel.com>;
<andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>; <alan@linux.intel.com>; <margie.foster@intel.com>; "Tomoya
MORINAGA" <morinaga526@dsn.okisemi.com>
Sent: Thursday, September 02, 2010 8:09 AM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35


> On Wed, Sep 01, 2010 at 09:16:30PM +0900, Masayuki Ohtak wrote:
> > Hi Greg,
> >
> > Sorry, we have modified again, for a bug(illegal return code) and
> > WARNING for building with the latest kernel.
> >
> > Please check below.
>
> Looks good.  Do you want me to queue it up for the .37 kernel merge
> through my tree, or through someone elses?
>
> thanks,
>
> greg k-h
>


