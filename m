Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab2GSE6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 00:58:39 -0400
Received: from 115-188-14-127.jetstream.xtra.co.nz ([115.188.14.127]:64685
	"EHLO SERVER.prisktech.co.nz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751979Ab2GSE6f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 00:58:35 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Alexey Charkov <alchark@gmail.com>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
CC: Tony Prisk <linux@prisktech.co.nz>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 1/1] Add Wondermedia Technologies (wmt) to
 docs/devicetree/vendor-bindings.txt
Thread-Topic: [PATCH 1/1] Add Wondermedia Technologies (wmt) to
 docs/devicetree/vendor-bindings.txt
Thread-Index: AQKYMMxC+/7sfLVv24SJcXAAzrg8wAJQSbLQAtZSvySVcT8RUA==
Date: Thu, 19 Jul 2012 04:56:06 +0000
Message-ID: <76F764B079F92A4E843589C893D0A022C381059B@SERVER.prisktech.co.nz>
References: <76F764B079F92A4E843589C893D0A022C380F1D4@SERVER.prisktech.co.nz>
 <201207171250.32265.arnd@arndb.de>
 <CABjd4Yyk6XR6RizgcpjCdi2N_+Z2EzTtezbkN9V7r4bAXXjhqA@mail.gmail.com>
In-Reply-To: <CABjd4Yyk6XR6RizgcpjCdi2N_+Z2EzTtezbkN9V7r4bAXXjhqA@mail.gmail.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given that there have been no replies to this thread, and the restart patch has
now been accepted using 'wmt' as the vendor namespace - would it be safe to
assume we should formalize this in the vendor-bindings.txt?

I'd like to try and have basic device tree support added for the next merge
window (or this one if it all goes well :) ), but it relies on the vendor binding being
formalized.

Regards,

Tony P

> -----Original Message-----
> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-kernel-bounces@lists.infradead.org] On Behalf Of Alexey
> Charkov
> Sent: Wednesday, 18 July 2012 1:31 a.m.
> To: vt8500-wm8505-linux-kernel@googlegroups.com
> Cc: Tony Prisk; devicetree-discuss@lists.ozlabs.org; Russell King; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH 1/1] Add Wondermedia Technologies (wmt) to docs/devicetree/vendor-bindings.txt
> 
> 2012/7/17 Arnd Bergmann <arnd@arndb.de>:
> > It would also be helpful to describe why the specific string is used here.
> > Normally we use the stock ticker symbol and "wmt" refers to Wal-Mart,
> > which would be unlikely but not impossible to produce their own hardware
> > in the future. The same thing applies to "via", which is VIACOM. The symbol
> > for VIA technologies is "2388.TW", but that is not particularly descriptive
> > or well-known.
> >
> > Maybe someone on the devicetree-discuss mailing list has a better
> > suggestion. I think using "via" is probably the best compromise, as
> > it's a well-known name and most of the components of the wondermedia
> > chips were first made by VIA anyway.
> 
> In fact, "wmt" is the name that the vendor itself uses in their GPL
> code (they also use mach-wmt as the arch-specific folder name). I
> believe that we could just as well use the full "wondermedia" word to
> avoid possible confusion, in case "wmt" is unacceptable for any
> reason.
> 
> Best,
> Alexey
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
