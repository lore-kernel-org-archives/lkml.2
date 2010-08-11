Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab0HKGbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 02:31:31 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:13645 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932550Ab0HKGba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 02:31:30 -0400
Message-ID: <000b01cb391e$d510a0f0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: <felipe.balbi@nokia.com>
Cc: "Greg KH" <gregkh@suse.de>, "Wang, Qi" <qi.wang@intel.com>,
        <arjan@linux.intel.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "LKML" <linux-kernel@vger.kernel.org>, <meego-dev@meego.com>
References: <4C612AA4.5040100@dsn.okisemi.com> <20100810171343.GE21220@suse.de> <D5AB6E638E5A3E4B8F4406B113A5A19A28EA2273@shsmsx501.ccr.corp.intel.com> <003001cb38fa$fcd15db0$66f8800a@maildom.okisemi.com> <20100811054905.GA25199@nokia.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to 2.6.35
Date: Wed, 11 Aug 2010 15:31:26 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbi

I can do well.

Thanks! Ohtake.

----- Original Message ----- 
From: "Felipe Balbi" <felipe.balbi@nokia.com>
To: "ext Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Greg KH" <gregkh@suse.de>; "Wang, Qi" <qi.wang@intel.com>; <arjan@linux.intel.com>; "Khor, Andrew Chih Howe"
<andrew.chih.howe.khor@intel.com>; "Wang, Yong Y" <yong.y.wang@intel.com>; "LKML" <linux-kernel@vger.kernel.org>;
<meego-dev@meego.com>
Sent: Wednesday, August 11, 2010 2:49 PM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to 2.6.35


> On Wed, Aug 11, 2010 at 04:14:51AM +0200, ext Masayuki Ohtake wrote:
> >> > > +#define TRUE 1
> >> > > +#define FALSE 0
> >> >
> >> > These lines should not be needed at all.
> >> OKI-san, please remove them, Those definition is useless.
> >
> >Is the above definition is necessary?
> >I can't find appropriate header file defines 'TRUE' and 'FALSE'.
>
> it's true and false. Lowercase. UNUSED is __unused.
>
> -- 
> balbi
>
> DefectiveByDesign.org
>


