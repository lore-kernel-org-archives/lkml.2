Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab2GYJvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 05:51:21 -0400
Received: from mta04.xtra.co.nz ([210.54.141.251]:48638 "EHLO mta01.xtra.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751325Ab2GYJvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 05:51:20 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jul 2012 05:51:20 EDT
From: "Sentient" <sentient@digitalfantasy.co.nz>
To: <vt8500-wm8505-linux-kernel@googlegroups.com>,
        "Tony Prisk" <linux@prisktech.co.nz>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Alexey Charkov'" <alchark@gmail.com>
References: <1342969400-21123-1-git-send-email-linux@prisktech.co.nz> <CAJOA=zNNE18DWwSgfh0H0zGgqpFhPeZrZ8zc0i_cxPBUc2VuoQ@mail.gmail.com>
In-Reply-To: <CAJOA=zNNE18DWwSgfh0H0zGgqpFhPeZrZ8zc0i_cxPBUc2VuoQ@mail.gmail.com>
Subject: RE: [PATCH] ARM: vt8500: clk: Add clock support for arch-vt8500
Date: Wed, 25 Jul 2012 21:40:09 +1200
Message-ID: <000001cd6a49$7bb8d500$732a7f00$@digitalfantasy.co.nz>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQKFSaZBTWIsB1THzIXIiufLq5p6nwFateaHlb8pzuA=
Content-Language: en-nz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Mike,

I might actually have a new patch up by then as the device tree support is coming along nicely.

Regards,
Tony

> -----Original Message-----
> From: vt8500-wm8505-linux-kernel@googlegroups.com [mailto:vt8500-wm8505-linux-kernel@googlegroups.com] On Behalf Of
> Turquette, Mike
> Sent: Wednesday, 25 July 2012 9:08 a.m.
> To: Tony Prisk
> Cc: VT8500 mailing list; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Russell King; Arnd Bergmann; Alexey
> Charkov
> Subject: Re: [PATCH] ARM: vt8500: clk: Add clock support for arch-vt8500
> 
> On Sun, Jul 22, 2012 at 8:03 AM, Tony Prisk <linux@prisktech.co.nz> wrote:
> > This patch adds common clock framework support for arch-vt8500.
> > WM8650 support is included in preparation for devicetree support.
> > Each SoC has a seperate initialization function due to no
> > devicetree support to identify SoCs at the moment. Once devicetree
> > is implemented, VT8500 and WM8505 should be combined. WM8650 uses
> > different functions for clocks.
> >
> > Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> 
> Hi Tony,
> 
> I'll give this a more thorough review once the -rc1 window is over.
> 
> Regards,
> Mike

