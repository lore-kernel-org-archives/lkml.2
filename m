Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab2F0MOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 08:14:08 -0400
Received: from antcom.de ([188.40.178.216]:34058 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554Ab2F0MOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 08:14:06 -0400
Message-ID: <4FEAF90B.5030809@antcom.de>
Date: Wed, 27 Jun 2012 14:14:03 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        dwmw2@infradead.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, hechtb@googlemail.com,
        lars@metafoo.de, b32955@freescale.com, leiwen@marvell.com,
        linux@arm.linux.org.uk
Subject: Re: [PATCH v7] MTD: LPC32xx SLC NAND driver
References: <1339064536-20553-1-git-send-email-stigge@antcom.de> <1340794007.29342.50.camel@sauron.fi.intel.com>
In-Reply-To: <1340794007.29342.50.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 12:46 PM, Artem Bityutskiy wrote:
> On Thu, 2012-06-07 at 12:22 +0200, Roland Stigge wrote:
>> This patch adds support for the SLC NAND controller inside the
>> LPC32xx SoC.
>> 
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> Now the write_page and write_page_raw functions return an error
> code, see this commit in the l2 tree:
> 
> http://git.infradead.org/users/dedekind/l2-mtd.git/commit/49c8d9ab3b70732665249f2d993f734378ebbba9
>
>  I've amended your SLC driver, see below the diff. But I think it
> could return the real return code becuse it can fail - could you
> please take a look and send an incremental patch?
> 
> Please, base your work on top of the l2-mtd tree: 
> git://git.infradead.org/users/dedekind/l2-mtd.git

Thanks for the note! I'm sending an incremental patch. There was
actually only one place in the two functions that could fail (return
code of lpc32xx_xfer()).

Roland
