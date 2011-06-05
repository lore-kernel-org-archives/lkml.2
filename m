Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab1FEVTi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 17:19:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44528 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab1FEVTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 17:19:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Cp359oZxRnRJPJt348mFa3ntJPB3kZmLuUILPtxH/PauymvXnH9CM0T7iKq+WBCcs+
         u85idKD6dEK8g0JsUZ5AHWsQ5ujrPesYCagMugeDWucTXluslSLbHVCESMx2M15tTjw7
         VTqJbia/uk+keSdJWWMIblFA8mBPdgfMpY2tM=
MIME-Version: 1.0
In-Reply-To: <BANLkTimgbxmBnTN9Sb55-hkbBi1AEfiPdg@mail.gmail.com>
References: <20110605071725.26517.11573.stgit@ponder>
	<BANLkTinoEQf2a65KwQZOVK_4H9DSfqybjA@mail.gmail.com>
	<20110605075458.GA2712@tarshish>
	<BANLkTi=5XLxcZiBcZT8W4Gh+Ph_BUjs-yw@mail.gmail.com>
	<BANLkTimgbxmBnTN9Sb55-hkbBi1AEfiPdg@mail.gmail.com>
Date: Mon, 6 Jun 2011 02:49:36 +0530
Message-ID: <BANLkTin1eQUO-at=Y1VZ7m42eWYqrNzHTA@mail.gmail.com>
Subject: Re: [PATCH] spi: reorganize drivers
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Baruch Siach <baruch@tkos.co.il>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Jun 5, 2011 at 5:49 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>>> Though the spi_ prefix seems redundant considering the files are in
>>>> 'spi' directory.
>>>> Just a thought, no objection.
>>>
>>> When looking at the list of loaded modules (e.g. in an Oops message), the name
>>> "spi_xilinx" is much more meaningful than just "xilinx", for example.
>>
>> Plus, when dropping the prefix, spi_xilinx.ko and gpio-xilinx.ko
>> become the same...
As I said, the modules could still be made spi_xilinx.ko from
drivers/spi/xilinx.c
and gpio_xilinx.ko from drivers/gpio/xilinx.c


On Mon, Jun 6, 2011 at 2:25 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> Perhaps we could get Makefile to build modules with spi_ prefix. Just
>> like USB gadgets do ?
> I don't think it's worth mucking about with <module_name>-y :=
> filename.o when the filename can just be made the same as the module
> name.
Well, the solution was for discarding the 'redundant' prefix and yet
have device specific
module names. Not just for the sake of it.

Anyways, I don't wanna be bitchy about it. I can buy at face value
from a maintainer.
I am ok with the proposed naming.

Cheers!
-j
