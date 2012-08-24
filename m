Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab2HXPOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 11:14:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33955 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab2HXPOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 11:14:01 -0400
MIME-Version: 1.0
In-Reply-To: <1345820228.87750.YahooMailNeo@web29604.mail.ird.yahoo.com>
References: <1345820228.87750.YahooMailNeo@web29604.mail.ird.yahoo.com>
Date: Fri, 24 Aug 2012 12:14:00 -0300
Message-ID: <CAOMZO5Ds6NKsTCptQXDGZDJasb119hYWqXMzX8nG5WFArysL7A@mail.gmail.com>
Subject: Re: SLAVE Side SPI kernel driver development
From: Fabio Estevam <festevam@gmail.com>
To: "Bastelli Carlo (yahoo)" <carlo_bastelli@yahoo.it>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marex@denx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 11:57 AM, Bastelli Carlo (yahoo)
<carlo_bastelli@yahoo.it> wrote:
> Hello, I'm Carlo, I have a difficult task at work, my boss asked me to
> develop
>  a driver SPI slave side on embedded ARM processor running Linux.
> Precisely linux occur on the SPI bus as a slave, not master as required
> by the hierarchical structure of the current kernel. The new driver
> will
>  receive via interrupt and respond when selected by its chip select. Can
>  anyone suggest the best way to develop this driver?. Personally, I
> have identified two main roads, the first if possible to exploit the
> structure SPI master driver, with a few tricks that now I can not
> define. The second most radical, write a driver for a UART like, but
> managing the SPI device.
> Thank you for any suggestions or examples.

Marek got spi slave running on a mx28. See his patch:
http://www.spinics.net/lists/arm-kernel/msg190860.html

Regards,

Fabio Estevam
