Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab2DTHxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 03:53:53 -0400
Received: from antcom.de ([188.40.178.216]:52330 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab2DTHxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 03:53:52 -0400
Message-ID: <4F91160B.5070802@antcom.de>
Date: Fri, 20 Apr 2012 09:53:47 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>, vitalywool@gmail.com,
        khali@linux-fr.org, ben-linux@fluff.org, rob.herring@calxeda.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH v4] i2c: Add device tree support to i2c-pnx.c
References: <1334850612-24151-1-git-send-email-stigge@antcom.de> <20120419160715.GD24987@pengutronix.de> <4F903E0C.6010604@antcom.de> <20120419203915.GB28005@pengutronix.de> <4F90812F.5090106@antcom.de> <20120420072811.GA9769@pengutronix.de>
In-Reply-To: <20120420072811.GA9769@pengutronix.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2012 09:28 AM, Wolfram Sang wrote:
>> Another solution would be to not use timeout with the dt enabled 
>> i2c-pnx for now (using the hard coded default timeout as the
>> current i2c-pnx.c does) and possibly introduce the (anyway
>> optional) "timeout" later.
> 
> Yeah, let's do it like this.

Good, will do!

>> Interesting! When the documentation is outdated - how does the
>> parser actually decide between hex (e.g. regs/addresses) and dec
>> (e.g. clock-frequency) in the absence of "0x"?
> 
> Are there regs without 0x?

Lots of, in Documentation/devicetree/booting-without-of.txt ;-)
Admittedly, not in arch/arm/boot/dts/*...

I would like to clarify the hex/dec issue and the various examples to
prevent confusion of others. Will post a patch.

Roland
