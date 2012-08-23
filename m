Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab2HWPV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:21:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52712 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab2HWPVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:21:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUo5UPLtUhf6_GafMj_kEnM25k+XYszdwsGwkGyCUC6zw@mail.gmail.com>
References: <1345551531-15348-1-git-send-email-stany.marcel@novasys-ingenierie.com>
	<CAMuHMdUo5UPLtUhf6_GafMj_kEnM25k+XYszdwsGwkGyCUC6zw@mail.gmail.com>
Date: Thu, 23 Aug 2012 17:21:23 +0200
X-Google-Sender-Auth: EfciIxzler_VupZBDELW7Pcqkx8
Message-ID: <CA+mBkFXnOB9hPoJVf6c92UuemqtLJwc2KW-G-ja6cG8VqLPZdw@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add support to broadcom 5222 PHY
From: Stany MARCEL <stany.marcel@novasys-ingenierie.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 12:47 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, Aug 21, 2012 at 2:18 PM, Stany MARCEL
> <stany.marcel@novasys-ingenierie.com> wrote:
>> Signed-off-by: Stany MARCEL <stany.marcel@novasys-ingenierie.com>
>> ---
>>
>>  This driver is an adaption of the one given by freescale for kernel 2.6.25.
>>
>>  Tested with kernel 3.4.8 with arch/m68k backported from linux-m68k head
>>  2 FEC configured with shared phy
>>
>>  drivers/net/phy/Kconfig        |    7 +-
>>  drivers/net/phy/Makefile       |    1 +
>>  drivers/net/phy/broadcom522x.c |  171 ++++++++++++++++++++++++++++++++++++++++
>
> This patch and "[PATCH 3/3] Add support to M54xx DMA FEC Driver" need to go
> through the netdev tree, or collect acks there.
>
> Gr{oetje,eeting}s,
>
>                         Geert
>

Hello Geert,

Please, what is the good process to follow as patch 3 depends on patch 1 ?

Submit 1 to m68k tree and wait for it to be pulled on mainline then
push 3 to netdev tree ?

Regards,

Stany
