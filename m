Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab2FKOeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:34:46 -0400
Received: from antcom.de ([188.40.178.216]:40106 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab2FKOep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:34:45 -0400
Message-ID: <4FD60203.8010103@antcom.de>
Date: Mon, 11 Jun 2012 16:34:43 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Subject: Re: [PATCH 8/14] ARM: LPC32xx: Clock adjustment for key matrix controller
References: <1339412537-24485-1-git-send-email-stigge@antcom.de> <1339412537-24485-9-git-send-email-stigge@antcom.de> <201206111416.19251.arnd@arndb.de>
In-Reply-To: <201206111416.19251.arnd@arndb.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/11/2012 04:16 PM, Arnd Bergmann wrote:
> On Monday 11 June 2012, Roland Stigge wrote:
>> The clock.c file needs to be changed to match the automatic device name to its
>> clock.
>>
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>> Acked-by: Rob Herring <rob.herring@calxeda.com>
>>
> 
> Should this not be in the same patch as the one that moves the device over
> to DT probing? Otherwise you have a non-working setup if only one patch
> is applied.

The actual driver is new for v3.6 (hopefully), DT-only.

Rather than merging the patches, I'd let the key driver go in via input,
and the clock.c adjustment via arm-soc.

Roland
