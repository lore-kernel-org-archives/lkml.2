Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2HWWBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 18:01:18 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59414 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab2HWWBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 18:01:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120823160255.GA32671@frolo.macqel>
References: <1345551531-15348-1-git-send-email-stany.marcel@novasys-ingenierie.com>
	<CAMuHMdUo5UPLtUhf6_GafMj_kEnM25k+XYszdwsGwkGyCUC6zw@mail.gmail.com>
	<CA+mBkFXnOB9hPoJVf6c92UuemqtLJwc2KW-G-ja6cG8VqLPZdw@mail.gmail.com>
	<20120823160255.GA32671@frolo.macqel>
Date: Fri, 24 Aug 2012 00:01:14 +0200
Message-ID: <CA+mBkFUuAuRS3+QcHG_HBCVrY6TGaEBOhuRtGD-ZzxjKLh7y2w@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add support to broadcom 5222 PHY
From: Stany MARCEL <stanypub@gmail.com>
To: Philippe De Muyter <phdm@macqel.be>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 6:02 PM, Philippe De Muyter <phdm@macqel.be> wrote:
> On Thu, Aug 23, 2012 at 05:21:23PM +0200, Stany MARCEL wrote:
>> On Thu, Aug 23, 2012 at 12:47 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>> > On Tue, Aug 21, 2012 at 2:18 PM, Stany MARCEL
>> > <stany.marcel@novasys-ingenierie.com> wrote:
>> >> Signed-off-by: Stany MARCEL <stany.marcel@novasys-ingenierie.com>
>> >> ---
>> >>
>> >>  This driver is an adaption of the one given by freescale for kernel 2.6.25.
>> >>
>> >>  Tested with kernel 3.4.8 with arch/m68k backported from linux-m68k head
>> >>  2 FEC configured with shared phy
>> >>
>> >>  drivers/net/phy/Kconfig        |    7 +-
>> >>  drivers/net/phy/Makefile       |    1 +
>> >>  drivers/net/phy/broadcom522x.c |  171 ++++++++++++++++++++++++++++++++++++++++
>> >
>> > This patch and "[PATCH 3/3] Add support to M54xx DMA FEC Driver" need to go
>> > through the netdev tree, or collect acks there.
>> >
>> > Gr{oetje,eeting}s,
>> >
>> >                         Geert
>> >
>>
>> Hello Geert,
>>
>> Please, what is the good process to follow as patch 3 depends on patch 1 ?
>
> Actually, IMHO patch 3 does not depend on patch 1, and I even think that
> patch 1 is not needed, except to get a message with "BCM5222" instead
> of "Generic PHY" in the kernel log.
>
> AFAIK the phy interface is standardized.
>
> Philippe

I meant patch 3 depends on patch 2 (multi channel dma api)
