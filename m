Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2ARL0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:26:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44138 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607Ab2ARL0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:26:30 -0500
Date: Wed, 18 Jan 2012 11:26:27 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 1/2] watchdog: wm8350_wdt: Fix handling
 WDIOS_DISABLECARD/WDIOS_ENABLECARD options
Message-ID: <20120118112627.GI8732@opensource.wolfsonmicro.com>
References: <1326885901.2984.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326885901.2984.1.camel@phoenix>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 07:25:01PM +0800, Axel Lin wrote:
> While receiving WDIOS_DISABLECARD option for WDIOC_SETOPTIONS command,
> call wm8350_wdt_stop() to disable watchdog.
> Call wm8350_wdt_start() while receiving WDIOS_ENABLECARD option.
> 
> Current code has reverse behavior.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
