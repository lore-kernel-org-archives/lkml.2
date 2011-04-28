Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910Ab1D1KUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:20:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40922 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758169Ab1D1KUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:20:03 -0400
Date: Thu, 28 Apr 2011 11:20:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: kalle.jokiniemi@nokia.com
Cc: Sakari.Ailus@nokia.com, lrg@slimlogic.co.uk, mchehab@infradead.org,
        svarbatov@mm-sol.com, saaguirre@ti.com, grosikopulos@mm-sol.com,
        vimarsh.zutshi@nokia.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC] Regulator state after regulator_get
Message-ID: <20110428102009.GB14494@opensource.wolfsonmicro.com>
References: <9D0D31AA57AAF5499AFDC63D6472631B09C76A@008-AM1MPN1-036.mgdnok.nokia.com>
 <4DB9348D.7000501@nokia.com>
 <9D0D31AA57AAF5499AFDC63D6472631B09C7BE@008-AM1MPN1-036.mgdnok.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9D0D31AA57AAF5499AFDC63D6472631B09C7BE@008-AM1MPN1-036.mgdnok.nokia.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 09:44:10AM +0000, kalle.jokiniemi@nokia.com wrote:

>  > Another alternative to the first option you proposed could be to add a
>  > flags field to regulator_consumer_supply, and use a flag to recognise
>  > regulators which need to be disabled during initialisation. The flag
>  > could be set by using a new macro e.g. REGULATOR_SUPPLY_NASTY() when
>  > defining the regulator.

> This sounds like a good option actually. Liam, Mark, any opinions?

I'm not sure what "supply_nasty" would mean?  This also doesn't seem
like something that we can set up per supply - it's going to affect the
whole regulator state, it's not something that only affects a single
supply.
