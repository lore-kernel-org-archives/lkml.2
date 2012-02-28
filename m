Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab2B1NIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:08:44 -0500
Received: from antcom.de ([188.40.178.216]:34245 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab2B1NIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:08:43 -0500
Message-ID: <4F4CD1D8.8030102@antcom.de>
Date: Tue, 28 Feb 2012 14:08:40 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: baruch@tkos.co.il
CC: alexander.h.duyck@intel.com, ian.campbell@citrix.com,
        netdev@vger.kernel.org, eilong@broadcom.com,
        Kevin Wells <kevin.wells@nxp.com>,
        Wolfram Sang <w.sang@pengutronix.de>, jeffrey.t.kirsher@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: LPC32xx: Ethernet driver
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2012-02-26 03:28 +100, David Miller wrote:
>> Please use a module_param() instead of a top level kernel parameter.
>
> Actually, remove this entirely, we don't add module parameters
> to force the ethernet address. That should be done in userland
> in some fashion.
>
> We've had many discussions about this recently, and this is the
> consistent policy we want to enforce in all drivers from now on.

Thanks for the note! I actually found out that in many cases, the
bootloader already initialized the hardware with the target MAC address
so we can use this one.

For the case that it _isn't_ initialized already, is it the right thing
to use a hard coded default MAC address to be replaced by the final one
in userspace? (I found such examples in some current micrel/ and amd/
drivers.)

Thanks in advance,

Roland
