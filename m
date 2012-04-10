Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab2DJLtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 07:49:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41580 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab2DJLto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 07:49:44 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120410100621.GF7499@opensource.wolfsonmicro.com>
References: <1333985710.16502.0.camel@phoenix> <20120410100621.GF7499@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 10 Apr 2012 19:49:23 +0800
Message-ID: <CAF+7xW=yH8Le2cbRhun=1R3DdUkETVedZt75Yt1LMsop-PQEzA@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: twl-regulator: Use DIV_ROUND_UP at
 appropriate places
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/10 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Mon, Apr 09, 2012 at 11:35:10PM +0800, Axel Lin wrote:
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Applied, thanks.
Hi Mark,
Seems you apply V2 of the patch.
The V3 is the correct one. https://lkml.org/lkml/2012/4/9/435

( the vsel++ after DIV_ROUND_UP is required because
    current code does subtract index by 1 in the list_voltage callback.
  e.g. current code uses this trick to differential setting voltage to
0 (vsel is 0) or  600000 uV (vsel is 1) )

Regards,
Axel
