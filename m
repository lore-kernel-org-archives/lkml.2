Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab2GSLQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 07:16:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62343 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab2GSLQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 07:16:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCH 1/1] Add Wondermedia Technologies (wmt) to docs/devicetree/vendor-bindings.txt
Date: Thu, 19 Jul 2012 11:16:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Tony Prisk <linux@prisktech.co.nz>, Alexey Charkov <alchark@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <76F764B079F92A4E843589C893D0A022C380F1D4@SERVER.prisktech.co.nz> <CABjd4Yyk6XR6RizgcpjCdi2N_+Z2EzTtezbkN9V7r4bAXXjhqA@mail.gmail.com> <76F764B079F92A4E843589C893D0A022C381059B@SERVER.prisktech.co.nz>
In-Reply-To: <76F764B079F92A4E843589C893D0A022C381059B@SERVER.prisktech.co.nz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207191116.27273.arnd@arndb.de>
X-Provags-ID: V02:K0:t3Cs2fVIidugG/1pXLQEickRxM/9eFP1T2iNHhDRJFL
 3gqknMMBKofxfKoF+INDh+l6a9Fa0TyWULcRqa4nkzRqYrS4h+
 MPjao9xSRjzq3ePIAUPx0onJzkFKLo3N5Ur+KA+mSw5OLSw8fL
 mC/mO5xHI94u01yS8NqKSw0uKAWCpy+yvez7U9AO5GwuOki8OC
 jh0RIqBfgYFZ/VmERUEObbCrYIeTKpK2TCndKCZVCF3oifn6Iw
 TcAfItYJtcf2cHyytjTgr190p4AEQ9cIlwLKJctHWeh4vbNdyT
 cmLFffXpSR46kAOw4IlwVA4cz2vz1nXk5ZRgE3GyM5q2PEvLxA
 N942ob+sF4qigu0MWAzg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
