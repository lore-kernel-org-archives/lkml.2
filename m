Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab2GXVIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:08:00 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:43872 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932083Ab2GXVH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:07:58 -0400
MIME-Version: 1.0
In-Reply-To: <1342969400-21123-1-git-send-email-linux@prisktech.co.nz>
References: <1342969400-21123-1-git-send-email-linux@prisktech.co.nz>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Tue, 24 Jul 2012 14:07:35 -0700
Message-ID: <CAJOA=zNNE18DWwSgfh0H0zGgqpFhPeZrZ8zc0i_cxPBUc2VuoQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: vt8500: clk: Add clock support for arch-vt8500
To: Tony Prisk <linux@prisktech.co.nz>
Cc: VT8500 mailing list <vt8500-wm8505-linux-kernel@googlegroups.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Alexey Charkov <alchark@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 8:03 AM, Tony Prisk <linux@prisktech.co.nz> wrote:
> This patch adds common clock framework support for arch-vt8500.
> WM8650 support is included in preparation for devicetree support.
> Each SoC has a seperate initialization function due to no
> devicetree support to identify SoCs at the moment. Once devicetree
> is implemented, VT8500 and WM8505 should be combined. WM8650 uses
> different functions for clocks.
>
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>

Hi Tony,

I'll give this a more thorough review once the -rc1 window is over.

Regards,
Mike
