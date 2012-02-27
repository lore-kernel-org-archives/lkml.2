Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2B0WEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:04:08 -0500
Received: from antcom.de ([188.40.178.216]:55110 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707Ab2B0WEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:04:07 -0500
Message-ID: <4F4BFDD2.8060007@antcom.de>
Date: Mon, 27 Feb 2012 23:04:02 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v3] ARM: LPC32xx: Ethernet support
References: <1330364762-23203-1-git-send-email-stigge@antcom.de> <20120227180814.GB21386@pengutronix.de>
In-Reply-To: <20120227180814.GB21386@pengutronix.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/12 19:08, Wolfram Sang wrote:
> On Mon, Feb 27, 2012 at 06:46:02PM +0100, Roland Stigge wrote:
>> This patch adds ethernet support to the LPC32xx ARM architecture.
>> The actual driver in drivers/net is contained in a separate
>> patch.
>> 
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>> 
>> ---
> 
> Please add below this dashed line what changed since the last
> version. This makes reviewing easier.

OK, will do next time.

For the driver, some style fixes were applied, and the cmdline
"ethaddr" was removed, relying on the bootloader to set it correctly
(and it actually does, it actually needs to prepare TFTP booting).

The platform-support patch just adjusted to the small driver change:
driver name adjustment ("lpc-eth") for consistency.

Roland
