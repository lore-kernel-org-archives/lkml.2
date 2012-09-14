Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399Ab2INKVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 06:21:23 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:45844 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab2INKVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 06:21:21 -0400
Date: Fri, 14 Sep 2012 12:21:06 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/4] i2c: introduce i2c-cbus driver
Message-ID: <20120914122106.12961546@endymion.delvare>
In-Reply-To: <20120914100806.GC2630@pengutronix.de>
References: <1346703805-31598-1-git-send-email-aaro.koskinen@iki.fi>
	<1346703805-31598-2-git-send-email-aaro.koskinen@iki.fi>
	<20120914100806.GC2630@pengutronix.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2012 12:08:06 +0200, Wolfram Sang wrote:
> OK, I found the short paragrahp about CBUS in the I2C spec, so I2C might
> be an appropriate place. Still, before deciding if it should rather be
> in the core directory, I still have a few questions.
> 
> Also, does anybody know of a generic bit-banging implementation in the
> kernel which could be used here?
> 
> Jean: I'd appreciate your general opinion here, too.

Out of time at the moment :(

-- 
Jean Delvare
