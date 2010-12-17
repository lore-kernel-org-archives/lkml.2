Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab0LQEym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 23:54:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:17896 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab0LQEyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 23:54:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,359,1288594800"; 
   d="scan'208";a="584588581"
From: "Lu, Hongjiu" <hongjiu.lu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Li, Shaohua" <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Huang, Ying" <ying.huang@intel.com>
Date: Thu, 16 Dec 2010 20:54:38 -0800
Subject: RE: [BUG]x86: relocatable doesn't work with new binutils
Thread-Topic: [BUG]x86: relocatable doesn't work with new binutils
Thread-Index: AcudmhdrH3ah+8gaQ7m1luoSx/rkwgADFMvg
Message-ID: <9DA5872FEF993D41B7173F58FCF6BE940505136F@orsmsx504.amr.corp.intel.com>
References: <1292553726.2323.482.camel@sli10-conroe>
	 <4D0AD1F9.7030704@zytor.com> <1292556114.2323.484.camel@sli10-conroe>
 <4D0AD7FF.5020103@zytor.com>
In-Reply-To: <4D0AD7FF.5020103@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oBH4t25T023483

I just released the Linux binutils 2.21.51.0.4:

http://gcc.gnu.org/ml/gcc/2010-12/msg00397.html


H.J.


> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Thursday, December 16, 2010 7:25 PM
> To: Li, Shaohua
> Cc: lkml; Andrew Morton; Lu, Hongjiu; Huang, Ying
> Subject: Re: [BUG]x86: relocatable doesn't work with new binutils
> 
> On 12/16/2010 07:21 PM, Shaohua Li wrote:
> > On Fri, 2010-12-17 at 10:59 +0800, H. Peter Anvin wrote:
> >> On 12/16/2010 06:42 PM, Shaohua Li wrote:
> >>> We can easily workaround this issue by moving jiffies to a section
> or at
> >>> least warn people if such binutils are using. what should we do?
> >>
> >> I think we should do the workaround, but still get distros to
> update the
> >> broken binutils.
> > Here is my workaround.
> > The problem is a lot of kernel versions are affected by this, fix
> all?
> 
> I suspect the stable kernels should be able to take the patch easily
> enough.
> 
> 	-hpa
> 
> 
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
