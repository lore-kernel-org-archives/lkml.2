Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab1D1LOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 07:14:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41899 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755817Ab1D1LOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 07:14:40 -0400
Date: Thu, 28 Apr 2011 12:14:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: kalle.jokiniemi@nokia.com
Cc: lrg@slimlogic.co.uk, mchehab@infradead.org, svarbatov@mm-sol.com,
        saaguirre@ti.com, grosikopulos@mm-sol.com, vimarsh.zutshi@nokia.com,
        Sakari.Ailus@nokia.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC] Regulator state after regulator_get
Message-ID: <20110428111447.GA19484@opensource.wolfsonmicro.com>
References: <9D0D31AA57AAF5499AFDC63D6472631B09C76A@008-AM1MPN1-036.mgdnok.nokia.com>
 <20110428100629.GA14494@opensource.wolfsonmicro.com>
 <9D0D31AA57AAF5499AFDC63D6472631B09C858@008-AM1MPN1-036.mgdnok.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9D0D31AA57AAF5499AFDC63D6472631B09C858@008-AM1MPN1-036.mgdnok.nokia.com>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 11:08:08AM +0000, kalle.jokiniemi@nokia.com wrote:

> I don't have a full set of regulators described, that's why things broke when
> I tried the regulator_full_constraints call earlier. But I don't think it would be too
> big issue to check the current after boot configuration and define all the
> regulators as you suggest. I will try this approach.

As I said in my previous mail if you've got a reagulator you don't know
about which is on you can give it an always_on constraint until you
figure out what (if anything) should be controlling it.
