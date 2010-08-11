Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab0HKGa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 02:30:29 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:13593 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623Ab0HKGa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 02:30:28 -0400
Message-ID: <000601cb391e$afec6b60$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Greg KH" <gregkh@suse.de>
Cc: "Wang, Qi" <qi.wang@intel.com>, <meego-dev@meego.com>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
        <arjan@linux.intel.com>
References: <002c01cb390e$80a58e50$66f8800a@maildom.okisemi.com> <20100811043952.GA4669@suse.de>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to 2.6.35
Date: Wed, 11 Aug 2010 15:30:20 +0900
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

> Use the 'bool' type, and 'true' and/or 'false' keywords instead.  That
> is the proper C idiom.
I can do well.

Thanks, Ohtake.

----- Original Message ----- 
From: "Greg KH" <gregkh@suse.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Wang, Qi" <qi.wang@intel.com>; <meego-dev@meego.com>; "LKML" <linux-kernel@vger.kernel.org>; "Wang, Yong Y"
<yong.y.wang@intel.com>; "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>; <arjan@linux.intel.com>
Sent: Wednesday, August 11, 2010 1:39 PM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to 2.6.35


> On Wed, Aug 11, 2010 at 01:34:33PM +0900, Masayuki Ohtake wrote:
> > Hi Qi-san
> >
> > I have found Macro 'TRUE' and 'FALSE' are used as setting value in the driver; still,
> > can't I use TRUE/FALSE macro ?
> > If not, How should we implement ?
>
> Use the 'bool' type, and 'true' and/or 'false' keywords instead.  That
> is the proper C idiom.
>
> thanks,
>
> greg k-h
>


