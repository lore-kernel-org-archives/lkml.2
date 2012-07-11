Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab2GKNjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:39:14 -0400
Received: from antcom.de ([188.40.178.216]:41554 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757694Ab2GKNjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:39:11 -0400
Message-ID: <4FFD81FD.4080103@antcom.de>
Date: Wed, 11 Jul 2012 15:39:09 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Subject: Re: [PATCH v2 04/23] ARM: LPC32xx: Add DMA configuration to platform
 data
References: <1339692673-7848-1-git-send-email-stigge@antcom.de> <201207111233.24780.arnd@arndb.de> <4FFD744F.8060204@antcom.de> <201207111325.03195.arnd@arndb.de>
In-Reply-To: <201207111325.03195.arnd@arndb.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 03:25 PM, Arnd Bergmann wrote:
> On Wednesday 11 July 2012, Roland Stigge wrote:
>> OK, thanks!
>>
>> Is a patch on top of the already provided lpc32xx-next branches the
>> preferred form for a fix? On top of which branch do you need it?
>>
> 
> Yes, I think in this case, changing it on top of that branch is best.

Good, thanks!

> I'm not sure how that works for the nand drivers though, since they
> are in another tree.

Will address this separately with the mtd/nand tree.

Roland
