Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab2FKO2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:28:44 -0400
Received: from antcom.de ([188.40.178.216]:56520 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037Ab2FKO2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:28:43 -0400
Message-ID: <4FD60096.7050603@antcom.de>
Date: Mon, 11 Jun 2012 16:28:38 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Subject: Re: [PATCH 11/14] ARM: LPC32xx: DTS adjustment for using pl18x primecell
References: <1339412537-24485-1-git-send-email-stigge@antcom.de> <1339412537-24485-12-git-send-email-stigge@antcom.de> <201206111414.14264.arnd@arndb.de>
In-Reply-To: <201206111414.14264.arnd@arndb.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 04:14 PM, Arnd Bergmann wrote:
> On Monday 11 June 2012, Roland Stigge wrote:
>>                         sd@20098000 {
>> -                               compatible = "arm,pl180", "arm,primecell";
>> +                               compatible = "arm,pl18x", "arm,primecell";
>>                                 reg = <0x20098000 0x1000>;
>>                                 interrupts = <0x0f 0>, <0x0d 0>;
>> +                               status = "disable";
>>                         };
>>  
> 
> The proper way to write this is 'status = "disabled";', with a 'd' at
> the end.

Thanks for the note!

Funnily, I always did it this way. Looks like initially, I copied from
somewhere else (wrongly). Indeed, we have lots of "disable", see also:

omap3-beagle.dts
omap4-panda.dts
omap4-sdp.dts
tegra20.dtsi
tegra30.dtsi

Roland
