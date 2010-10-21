Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab0JUQTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 12:19:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45249 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751373Ab0JUQTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 12:19:38 -0400
Date: Thu, 21 Oct 2010 09:19:06 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: rklein@nvidia.com, Anton Vorontsov <cbouatmailru@gmail.com>,
        achew@nvidia.com, olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] POWER: Add gpio charger driver
Message-ID: <20101021161901.GE9447@opensource.wolfsonmicro.com>
References: <1287663957-30099-1-git-send-email-lars@metafoo.de>
 <1287676501-23254-1-git-send-email-lars@metafoo.de>
 <20101021160008.GD9447@opensource.wolfsonmicro.com>
 <4CC06760.1080808@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC06760.1080808@metafoo.de>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 06:16:32PM +0200, Lars-Peter Clausen wrote:
> Mark Brown wrote:
> > It would be good to handle IRQs that can sleep (like those on I2C GPIO
> > expanders) here - either always use a threaded IRQ handler (probably
> > won't hurt here) or use one if the IRQ can sleep.

> I guess the best would be to use `request_any_context_irq`, right?

Ah, that got merged now - yes, that'd be best.
