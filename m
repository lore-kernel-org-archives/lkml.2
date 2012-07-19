Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab2GSLs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 07:48:29 -0400
Received: from 115-188-14-127.jetstream.xtra.co.nz ([115.188.14.127]:58211
	"EHLO SERVER.prisktech.co.nz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753179Ab2GSLs1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 07:48:27 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Arnd Bergmann <arnd@arndb.de>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
CC: Alexey Charkov <alchark@gmail.com>,
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
Thread-Index: AQKYMMxC+/7sfLVv24SJcXAAzrg8wAJQSbLQAtZSvySVcT8RUP//oSgAgADM584=
Date: Thu, 19 Jul 2012 11:45:59 +0000
Message-ID: <76F764B079F92A4E843589C893D0A022C3811BFD@SERVER.prisktech.co.nz>
References: <76F764B079F92A4E843589C893D0A022C380F1D4@SERVER.prisktech.co.nz>
 <CABjd4Yyk6XR6RizgcpjCdi2N_+Z2EzTtezbkN9V7r4bAXXjhqA@mail.gmail.com>
 <76F764B079F92A4E843589C893D0A022C381059B@SERVER.prisktech.co.nz>,<201207191116.27273.arnd@arndb.de>
In-Reply-To: <201207191116.27273.arnd@arndb.de>
Accept-Language: en-GB, en-NZ, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann [arnd@arndb.de]
Sent: 19 July 2012 23:16
To: vt8500-wm8505-linux-kernel@googlegroups.com
Cc: Tony Prisk; Alexey Charkov; devicetree-discuss@lists.ozlabs.org; Russell King; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] Add Wondermedia Technologies (wmt) to docs/devicetree/vendor-bindings.txt

On Thursday 19 July 2012, Tony Prisk wrote:
> Given that there have been no replies to this thread, and the restart patch has
> now been accepted using 'wmt' as the vendor namespace - would it be safe to
> assume we should formalize this in the vendor-bindings.txt?
>
> I'd like to try and have basic device tree support added for the next merge
> window (or this one if it all goes well :) ), but it relies on the vendor binding being
> formalized.

What about devices that come from via though? Anything that first showed up
in vt8500 or earlier should probably get a prefix identifying VIA rather
than WonderMedia.

        Arnd


I have no issue with that.

I am mainly concerned with the Wondermedia products at the moment.

Adding device tree support for WM8505 (and WM8650) is my main goal as the WM8650
currently isn't supported and trying to get another board file added seems unlikely with
everything moving to device tree. The VT8500 requires additional/different patches and
as I don't have a vt8500 I can't test them.

It does raise the question of applying 'wmt, prizm-pmc' to the vt8500 though. While it's
fine for the restart patch I submitted, the vt8500 registers are the same but the bit-fields
are different and therefore not entirely compatible with 'prizm-pmc'.
When it comes to other PMC-related features, in particular the clocks, the VT8500 is quite
different in its bit-fields.

The vt8500 isn't technically in the Prizm family, as that is Wondermedia's name for the SoC's.


Regard

Tony P