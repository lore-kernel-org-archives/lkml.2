Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506Ab0D3Roa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:44:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50452 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933480Ab0D3Rnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:43:47 -0400
Subject: Re: [PATCH 0/3] regulator: small fixes and cleanup
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
In-Reply-To: <cover.1272526450.git.ext-jani.1.nikula@nokia.com>
References: <cover.1272526450.git.ext-jani.1.nikula@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Apr 2010 14:29:10 +0100
Message-ID: <1272547750.4296.38.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-29 at 10:55 +0300, Jani Nikula wrote:
> Hi -
> 
> Here's a few small fixes to problems I think I found in the regulator
> framework. Please give them some thought; I don't know the area very well.
> 
> BR,
> Jani.
> 
> 
> Jani Nikula (3):
>   regulator: prevent registration of matching regulator consumer
>     supplies
>   regulator: fix unset_regulator_supplies() to remove all matches
>   regulator: simplify regulator_register() error handling
> 
>  drivers/regulator/core.c |   43 +++++++++++--------------------------------
>  1 files changed, 11 insertions(+), 32 deletions(-)
> 

All applied.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

