Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2GKMkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:40:53 -0400
Received: from antcom.de ([188.40.178.216]:40045 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab2GKMkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:40:51 -0400
Message-ID: <4FFD744F.8060204@antcom.de>
Date: Wed, 11 Jul 2012 14:40:47 +0200
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
References: <1339692673-7848-1-git-send-email-stigge@antcom.de> <201207102136.35944.arnd@arndb.de> <4FFD393F.1070104@antcom.de> <201207111233.24780.arnd@arndb.de>
In-Reply-To: <201207111233.24780.arnd@arndb.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 02:33 PM, Arnd Bergmann wrote:
> On Wednesday 11 July 2012, Roland Stigge wrote:
>> Thanks for the note! Looks like the interface consolidated to replace
>> ch->cd->min_signal with sth. like cd->min_signal directly.
>>
>> Accessing the signal id/number is/was quite convenient because as you
>> can see in the 3 above cases that now get compile errors with the pl08x
>> changes, the LPC32xx chip hard-wires those numbers, and the respective
>> code is LPC32xx specific anyway.
>>
>> So can we make an exception here to compare static dma channel numbers?
>> Or is there any other interface to access the static dma channel numbers
>> that I'm currently not aware of?
>>
>> Depending on what we agree upon, I can then provide fixes to the
>> lpc32xx-next branch.
> 
> I'm not familiar with this code, but I think the solution for now
> (while we don't have a DT binding) is to do the same thing that
> spear3xx does: pass a pointer to the global pl08x_filter_id
> function and an identifier for the channel in the platform data
> for that device.

OK, thanks!

Is a patch on top of the already provided lpc32xx-next branches the
preferred form for a fix? On top of which branch do you need it?

Thanks in advance,

Roland
