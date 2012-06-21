Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab2FUIUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:20:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53239 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758533Ab2FUIUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:20:47 -0400
From: Florian Fainelli <florian@openwrt.org>
To: linux-mips@linux-mips.org
Cc: Kelvin Cheung <keguang.zhang@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, zhzhl555@gmail.com
Subject: Re: [PATCH V7 2/4] MIPS: Add board support for Loongson1B
Date: Thu, 21 Jun 2012 10:18:16 +0200
Message-ID: <5405989.s3J3Yyxttn@flexo>
Organization: OpenWrt
User-Agent: KMail/4.8.3 (Linux/3.2.0-24-generic; KDE/4.8.3; x86_64; ; )
In-Reply-To: <CAJhJPsV2D3xVbA93OpaB8mN6Vs64EmWjxhCbpCMBA5r+wx8mnQ@mail.gmail.com>
References: <1339757617-2187-1-git-send-email-keguang.zhang@gmail.com> <20120620192551.GC29446@linux-mips.org> <CAJhJPsV2D3xVbA93OpaB8mN6Vs64EmWjxhCbpCMBA5r+wx8mnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 June 2012 15:34:54 Kelvin Cheung wrote:
> 2012/6/21 Ralf Baechle <ralf@linux-mips.org>
[snip]
> >
> > And the final plug - take a look at FDT for a future revision of this
> > code :)
> >
> >
> Yes, I am aware that the FDT is the final target.
> But PMON which is the bootloader of Loongson CPU does not support FDT at
> present.
> I will remember this.

Your bootloader does not need to support FDT, as long as you can provide a FDT 
by other means, such as appending a FDT at the end of your kernel.
--
Florian
