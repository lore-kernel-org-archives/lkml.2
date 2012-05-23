Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219Ab2EWBmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:42:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:55037 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927Ab2EWBmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:42:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103125443"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: Michal Nazarewicz <mina86@mina86.com>,
        "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>
CC: "'David Rientjes'" <rientjes@google.com>,
        "'Sergei Shtylyov'" <sshtylyov@mvista.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "'balbi@ti.com'" <balbi@ti.com>, "'hpa@zytor.com'" <hpa@zytor.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-usb@vger.kernel.org'" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH] testusb: enable option "-l" in command line
Thread-Topic: [PATCH] testusb: enable option "-l" in command line
Thread-Index: AQHNOAZnKpWibM0wl0y/lnD4BzW+SJbVnhoQgAAvmwCAAMvhgA==
Date: Wed, 23 May 2012 01:42:37 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A063C63@SHSMSX101.ccr.corp.intel.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A063BF8@SHSMSX101.ccr.corp.intel.com>
 <op.weqba0m63l0zgt@mpn-glaptop>
In-Reply-To: <op.weqba0m63l0zgt@mpn-glaptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4N1gnXv021145

> On Tue, 22 May 2012 03:40:28 -0700, Du, ChangbinX <changbinx.du@intel.com>
> wrote:
> > The "-l" option which makes test function loops forever, can be used for
> > usb stress test. But it is not usable yet, so enable it.
> 
> This sentence is confusing (at least to me).  How about something like:
> 
> 	The testusb.c tool has support for looping forever implemented, which
> 	may be useful for stress test, yet it is not exposed to the user, so
> 	even though the code is there, it cannot be used.  This commit adds
> 	â€œlâ€ to the set of options handled by the application which enables
> 	the feature.

Yes, your description is much more appropriate. I will resend. Thanks.

Du Changibn.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
