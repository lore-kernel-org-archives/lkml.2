Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2HSIre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 04:47:34 -0400
Received: from antcom.de ([188.40.178.216]:51307 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab2HSIr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 04:47:28 -0400
Message-ID: <5030A81E.5090508@antcom.de>
Date: Sun, 19 Aug 2012 10:47:26 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: kevin.wells@nxp.com, vitalywool@gmail.com, khali@linux-fr.org,
        ben-linux@fluff.org, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com, jonsmirl@gmail.com
Subject: Re: [PATCH RESEND 1/2] i2c: pnx: Fix bit definitions
References: <1344411752-23469-1-git-send-email-stigge@antcom.de> <20120818095108.GB24812@pengutronix.de>
In-Reply-To: <20120818095108.GB24812@pengutronix.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/08/12 11:51, Wolfram Sang wrote:
> On Wed, Aug 08, 2012 at 09:42:31AM +0200, Roland Stigge wrote:
>> The I2C Control Register bits RFDAIE and RFFIE were mixed up. In
>> addition to this fix, this patch adds the missing bit DRSIE for
>> completeness.
>> 
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>> 
>> --- Applies to v3.6-rc1
>> 
>> This patch for i2c-pnx affects PNX4008 and LPC32xx (and LPC31xx,
>> not yet in mainline). Can you please test and double-check the
>> manuals of PNX4008 and LPC31xx? I only found this via the manual
>> of LPC32xx but assume it's the same for the others, also.
>> 
>> Thanks in advance!
> 
> Kevin, since the other manuals seem to be not easily available, can
> you please check?

Yes, would be great if someone at NXP could confirm that PNX actually
uses the same IP core for the I2C controller as LPCs do (which is
currently assumed by Linux anyway).

Thanks in advance,

Roland
