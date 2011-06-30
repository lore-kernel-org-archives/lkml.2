Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab1F3IXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:23:49 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57867 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1F3IXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:23:46 -0400
MIME-Version: 1.0
In-Reply-To: <1309408494.10500.1.camel@phoenix>
References: <1309408494.10500.1.camel@phoenix>
Date: Thu, 30 Jun 2011 12:23:45 +0400
Message-ID: <BANLkTikonD2fcbkBU2ESYm_XncBXNZc_hw@mail.gmail.com>
Subject: Re: [PATCH] mtd: tmio_nand: fix build error
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/30/11, Axel Lin <axel.lin@gmail.com> wrote:
> Fix a mistake introduced by commit 33f4a3b
> "mtd: tmio_nand.c: use mtd_device_parse_register"

Already sumbited 27 June 2011. Strangely Artem remains silent.

>   CC [M]  drivers/mtd/nand/tmio_nand.o
> drivers/mtd/nand/tmio_nand.c:461:35: error: macro "mtd_device_register"
> passed 5 arguments, but takes just 3
> drivers/mtd/nand/tmio_nand.c: In function 'tmio_probe':
> drivers/mtd/nand/tmio_nand.c:459: error: 'mtd_device_register' undeclared
> (first use in this function)
> drivers/mtd/nand/tmio_nand.c:459: error: (Each undeclared identifier is
> reported only once
> drivers/mtd/nand/tmio_nand.c:459: error: for each function it appears in.)
> make[3]: *** [drivers/mtd/nand/tmio_nand.o] Error 1
> make[2]: *** [drivers/mtd/nand] Error 2
> make[1]: *** [drivers/mtd] Error 2
> make: *** [drivers] Error 2

-- 
With best wishes
Dmitry
