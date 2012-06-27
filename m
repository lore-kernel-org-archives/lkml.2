Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab2F0P0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:26:21 -0400
Received: from antcom.de ([188.40.178.216]:39048 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757413Ab2F0P0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:26:19 -0400
Message-ID: <4FEB2619.8020000@antcom.de>
Date: Wed, 27 Jun 2012 17:26:17 +0200
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
References: <1339064536-20553-1-git-send-email-stigge@antcom.de>  <1340794007.29342.50.camel@sauron.fi.intel.com>  <4FEAF90B.5030809@antcom.de> <1340800392.1799.17.camel@sauron.fi.intel.com>
In-Reply-To: <1340800392.1799.17.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 02:33 PM, Artem Bityutskiy wrote:
> On Wed, 2012-06-27 at 14:14 +0200, Roland Stigge wrote:
>> Thanks for the note! I'm sending an incremental patch. There was 
>> actually only one place in the two functions that could fail
>> (return code of lpc32xx_xfer()).
> 
> Could you please check the MCL patch as well and re-send it against
> the l2 tree?
> 
> I've squashed your change into the driver and pushed out, thanks!

Yes, thanks!

Will post an updated MLC against l2-mtd later today.

Roland
