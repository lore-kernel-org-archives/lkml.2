Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1JWL4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 07:56:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40428 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755398Ab1JWL4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 07:56:14 -0400
Date: Sun, 23 Oct 2011 13:56:13 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mfd: Add s5m series irq support
Message-ID: <20111023115612.GB22871@opensource.wolfsonmicro.com>
References: <009301cc915a$cd72d1c0$68587540$@com>
 <20111023084233.GB3135@opensource.wolfsonmicro.com>
 <009801cc9171$c4ea1970$4ebe4c50$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009801cc9171$c4ea1970$4ebe4c50$@com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 07:51:50PM +0900, Sangbeom Kim wrote:
> On Sun, Oct 23, 2011 at 05:43 PM , Mark Brown wrote:

> > Actually, one of the things I want to do in the 3.3 timeframe is to
> > factor out this code from my drivers into a regmap based irq_chip since
> > it seems a lot of people are "drawing inspiration" from it.  This
> > shouldn't be any form of blocker for merging this driver though.

> I hope that this driver will be base code for regmap based irq driver
> I want discuss more detail in Prague.

Like I say, the code does look rather familiar to me :P
