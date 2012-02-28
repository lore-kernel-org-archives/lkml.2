Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891Ab2B1Ncx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:32:53 -0500
Received: from antcom.de ([188.40.178.216]:38014 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab2B1Ncw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:32:52 -0500
Message-ID: <4F4CD781.2090802@antcom.de>
Date: Tue, 28 Feb 2012 14:32:49 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: baruch@tkos.co.il, alexander.h.duyck@intel.com, ian.campbell@citrix.com,
        netdev@vger.kernel.org, eilong@broadcom.com,
        Kevin Wells <kevin.wells@nxp.com>,
        Wolfram Sang <w.sang@pengutronix.de>, jeffrey.t.kirsher@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] ARM: LPC32xx: Ethernet driver
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E83@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6E83@saturn3.aculab.com>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/28/2012 02:11 PM, David Laight wrote:
>> Thanks for the note! I actually found out that in many cases, the
>> bootloader already initialized the hardware with the target 
>> MAC address so we can use this one.
>>
>> For the case that it _isn't_ initialized already, is it the right
> thing
>> to use a hard coded default MAC address to be replaced by the final
> one
>> in userspace? (I found such examples in some current micrel/ and amd/
> drivers.)
> 
> Using a fixed address is a very bad idea ...

Yes, that's why we previously had a cmdline param for it (but removed it
upon request from the netdev maintainer).

So if the hardware defaults to 00:00:00:00:00:00, what is the
"consistent policy we want to enforce in all drivers"?

A link or hint would be sufficient.

Thanks in advance,

Roland
