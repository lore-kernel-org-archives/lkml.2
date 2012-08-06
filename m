Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab2HFMVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:21:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54018 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756118Ab2HFMUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:20:55 -0400
Date: Mon, 6 Aug 2012 13:20:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH] regmap-irq: allow auto-allocated IRQs to be mapped
Message-ID: <20120806122052.GC16861@opensource.wolfsonmicro.com>
References: <201208020805.q72858Yj003147@latitude.olech.com>
 <20120804105424.GB10523@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032C30AC@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51032C30AC@NB-EX-MBX02.diasemi.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2012 at 07:57:19PM +0000, Opensource [Anthony Olech] wrote:
> Hi Mark,

Don't send top posted mails and fix your mail client ti wrod wrap within
paragraphs.

> The problem is that the auto allocated "irq_base" comes back as zero.

> I repeat - in v3.4 the daa9058 driver work, but fails (without my
> patch) in v3.5

> If my suggested fix is not acceptable, then is it possible to fix the
> bug in some other way?

To repeat, your driver is buggy, any irq_base should be specified by
platform data.  Your driver should stop doing whatever it is doing that
relies on having an irq_base.
