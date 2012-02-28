Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab2B1NuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:50:01 -0500
Received: from antcom.de ([188.40.178.216]:40486 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451Ab2B1NuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:50:00 -0500
Message-ID: <4F4CDB84.7070502@antcom.de>
Date: Tue, 28 Feb 2012 14:49:56 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: David Laight <David.Laight@aculab.com>, baruch@tkos.co.il,
        alexander.h.duyck@intel.com, ian.campbell@citrix.com,
        netdev@vger.kernel.org, eilong@broadcom.com,
        Kevin Wells <kevin.wells@nxp.com>,
        Wolfram Sang <w.sang@pengutronix.de>, jeffrey.t.kirsher@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: LPC32xx: Ethernet driver
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E83@saturn3.aculab.com> <4F4CD781.2090802@antcom.de> <201202281341.01690.arnd@arndb.de>
In-Reply-To: <201202281341.01690.arnd@arndb.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2012 02:41 PM, Arnd Bergmann wrote:
>> So if the hardware defaults to 00:00:00:00:00:00, what is the
>> "consistent policy we want to enforce in all drivers"?
>>
>> A link or hint would be sufficient.
> 
> I think the most common strategy for platform drivers these days is
> 
> 1. use what the hardware provides
> 2. call of_get_mac_address(dev->of_node, ...)
> 3. use random_ether_addr
> 
> in that order. of_get_mac_address just returns NULL when there
> is no device tree or no local-mac-address property, so you can
> put it into the driver right away.

Cool, thanks - will do!

Roland
