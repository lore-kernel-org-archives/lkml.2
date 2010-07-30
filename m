Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab0G3GLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 02:11:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40985 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab0G3GLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 02:11:42 -0400
MIME-Version: 1.0
In-Reply-To: <20100730135721.5c1df39c.sfr@canb.auug.org.au>
References: <20100730135721.5c1df39c.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 30 Jul 2010 00:11:21 -0600
X-Google-Sender-Auth: 3x0zvBwxmoAUA3xGHGcsdsHnm68
Message-ID: <AANLkTiknZ8xMEj3vJKrgCVfwepGmaveV2X+Ai5BP=BYm@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the devicetree tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anatolij Gustschin <agust@denx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 9:57 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> After merging the devicetree tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/spi/xilinx_spi.c: In function 'xilinx_spi_init':
> drivers/spi/xilinx_spi.c:393: error: 'struct device' has no member named 'of_node'
> drivers/spi/xilinx_spi.c:393: error: 'struct device' has no member named 'of_node'
>
> Caused by commit 65b25b3c3080d96c42b31e0d97e7fcf4fabceeb4 ("of/spi: call
> of_register_spi_devices() from spi core code").
>
> I have used the devicetree tree from next-20100729 for today.

Thanks Stephen.  Should be fixed now.

g.
