Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934186Ab2GLRlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:41:42 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:58708 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932285Ab2GLRll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:41:41 -0400
Date: Thu, 12 Jul 2012 19:40:57 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Sylver Bruneau <sylver.bruneau@googlemail.com>,
        linux-watchdog@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Jamie Lentin <jm@lentin.co.uk>, AndrewLunn <andrew@lunn.ch>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH RFT] watchdog: Convert orion_wdt driver to watchdog core
Message-ID: <20120712174057.GG735@spo001.leaseweb.com>
References: <1339744964.20824.5.camel@phoenix> <20120618140101.GP4799@lunn.ch> <1341984796.4158.2.camel@phoenix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1341984796.4158.2.camel@phoenix>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

> 於 一，2012-06-18 於 16:01 +0200，Andrew Lunn 提到：
> > On Fri, Jun 15, 2012 at 03:22:44PM +0800, Axel Lin wrote:
> > > Convert the orion_wdt driver to the watchdog framework API.
> > > 
> > > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > 
> > Hi Axel
> > 
> > Tested-by: Andrew Lunn <andrew@lunn.ch>
> 
> Hi Wim,
> This patch has been tested by Andrew Lunn.
> I notice you have not (yet) picked up this patch.
> Any comments?

Added into linux-watchdog-next (after removing the addition of a double #include <linux/watchdog.h> line).

Kind regards,
Wim.

