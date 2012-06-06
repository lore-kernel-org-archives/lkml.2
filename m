Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2FFJBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:01:50 -0400
Received: from antcom.de ([188.40.178.216]:41235 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab2FFJBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:01:48 -0400
Message-ID: <4FCF1C78.5000309@antcom.de>
Date: Wed, 06 Jun 2012 11:01:44 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        dwmw2@infradead.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, hechtb@googlemail.com,
        lars@metafoo.de, b32955@freescale.com, leiwen@marvell.com,
        linux@arm.linux.org.uk
Subject: Re: [PATCH v5] MTD: LPC32xx SLC NAND driver
References: <1338837901-24075-1-git-send-email-stigge@antcom.de> <1338972168.6875.7.camel@sauron.fi.intel.com>
In-Reply-To: <1338972168.6875.7.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2012 10:42 AM, Artem Bityutskiy wrote:
> On Mon, 2012-06-04 at 21:25 +0200, Roland Stigge wrote:
>> +config MTD_NAND_SLC_LPC32XX +	bool "NXP LPC32xx SLC Controller"
> 
> Why bool and not tristate here? Why you force this to be
> compiled-in and make it impossible to be a kernel module like other
> drivers are?

Right - the solution for both issues you mention (compiling as module
and linker error) is replacing above "bool" with "tristate".

Will post an updated patch.

Thanks,

Roland
