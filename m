Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1H2JEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 05:04:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:64040 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab1H2JEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 05:04:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,296,1312182000"; 
   d="scan'208";a="43450636"
From: "Ren, Yongjie" <yongjie.ren@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Date: Mon, 29 Aug 2011 17:03:16 +0800
Subject: RE: [Bug #39412] Win Vista and Win2K8 guests' network breaks down
Thread-Topic: [Bug #39412] Win Vista and Win2K8 guests' network breaks down
Thread-Index: Acxlut0hb2+luX8wQbiZ/7XBOHKyMgAbhqKw
Message-ID: <CE59C043D0EC3349B2BF41C0EC72229B12D24D15E8@shsmsx501.ccr.corp.intel.com>
References: <Sm7qbRR0zn.A.yAG.LepWOB@chimera>
 <gUVi6eNP8RE.A.IBH.TfpWOB@chimera>
In-Reply-To: <gUVi6eNP8RE.A.IBH.TfpWOB@chimera>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7T94iXS016653

I've verified this bug in Linus' tree 3.1.0-rc4. It got fixed, so I closed the bug.
The commit I tried is below.
commit c6a389f123b9f68d605bb7e0f9b32ec1e3e14132
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Aug 28 21:16:01 2011 -0700

Best Regards,
     Yongjie Ren  (Jay)

> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Monday, August 29, 2011 3:01 AM
> To: Linux Kernel Mailing List
> Cc: Kernel Testers List; Maciej Rutecki; Florian Mickler; Avi Kivity; Ren, Yongjie;
> Marcelo Tosatti; Stefan Hajnoczi
> Subject: [Bug #39412] Win Vista and Win2K8 guests' network breaks down
> 
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.39 and 3.0.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.39 and 3.0.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=39412
> Subject		: Win Vista and Win2K8 guests' network breaks down
> Submitter	: Jay Ren <yongjie.ren@intel.com>
> Date		: 2011-07-15 15:31 (45 days old)
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
