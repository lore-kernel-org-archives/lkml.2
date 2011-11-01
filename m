Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab1KAMCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:02:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52229 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942Ab1KAMCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:02:09 -0400
Date: Tue, 1 Nov 2011 12:02:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the watchdog tree
Message-ID: <20111101120206.GB10029@opensource.wolfsonmicro.com>
References: <20111101163748.26d5f1264b56961e36ff0ced@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101163748.26d5f1264b56961e36ff0ced@canb.auug.org.au>
X-Cookie: Avoid reality at all costs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 04:37:48PM +1100, Stephen Rothwell wrote:

> drivers/watchdog/wm831x_wdt.c: In function 'wm831x_wdt_start':
> drivers/watchdog/wm831x_wdt.c:56:40: error: 'struct watchdog_device' has no member named 'priv'
> drivers/watchdog/wm831x_wdt.c: In function 'wm831x_wdt_stop':

Wim, it looks from this error like you've applied the original version of
this I sent on 20th July against the then current API, not the updated
version I sent on 25th July (which was resent on 4th October) after you
revised the API.
