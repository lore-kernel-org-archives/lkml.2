Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab0HLBNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 21:13:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:61193 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757571Ab0HLBNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 21:13:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,355,1278313200"; 
   d="scan'208";a="826863129"
From: "Wang, Qi" <qi.wang@intel.com>
To: Greg KH <gregkh@suse.de>, Masayuki Ohtake <masa-korg@dsn.okisemi.com>
CC: "meego-dev@meego.com" <meego-dev@meego.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>
Date: Thu, 12 Aug 2010 09:13:24 +0800
Subject: RE: [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to
 2.6.35
Thread-Topic: [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to
 2.6.35
Thread-Index: Acs5aI/p4M4zCOgTQ3uw2VOj/l8WvgAUpOdQ
Message-ID: <D5AB6E638E5A3E4B8F4406B113A5A19A28EA26B2@shsmsx501.ccr.corp.intel.com>
References: <4C612AA4.5040100@dsn.okisemi.com>
 <20100810171343.GE21220@suse.de>
 <002601cb3926$edaf24d0$66f8800a@maildom.okisemi.com>
 <20100811151510.GB9180@suse.de>
In-Reply-To: <20100811151510.GB9180@suse.de>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7C1Dx5W007544

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Wednesday, August 11, 2010 11:15 PM
> To: Masayuki Ohtake
> Cc: meego-dev@meego.com; LKML; Wang, Qi; Wang, Yong Y; Khor, Andrew
> Chih Howe; arjan@linux.intel.com
> Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to
> 2.6.35
> 
> On Wed, Aug 11, 2010 at 04:29:25PM +0900, Masayuki Ohtake wrote:
> > Hi Greg,
> >
> > > Do they all have to be ioctls?  What exactly are they doing?
> > I think using ioctl is common for this patch.
> 
> "Common" is not ok, right?
> 
> > Do you think that using ioctl is NOT appropriate for this patch?
> 
> Yes.
> 
> > Let me know your intension in more detail.
> 
> Please express yours.  Why do you feel you need these to be ioctls?
> What exactly are they doing?  Where is the documentation for them all?
> 
> > > And are they 32/64bit safe?
> > Only 32bit support.
> 
> That's an obvious problem that needs to be resolved, right?
The Tunnelcreak processor (A kind of Atom-based processor) only supports 32b, so PCH drivers only support 32b.
They can make it 32/64 compatible, but it's difficult to test them, because there're no 64b Atom-based platform have those PCH devices.

Best Regards,
QI.
> 
> thanks,
> 
> greg k-h
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
