Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab2EGFUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 01:20:48 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:55178 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2EGFUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 01:20:47 -0400
Date: Mon, 7 May 2012 14:20:40 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-sh@vger.kernel.org,
        johnstul@us.ibm.com, rjw@sisk.pl, lethal@linux-sh.org,
        gregkh@linuxfoundation.org, olof@lixom.net, tglx@linutronix.de
Subject: Re: [PATCH] clocksource: em_sti: Emma Mobile STI driver
Message-ID: <20120507052028.GA26593@verge.net.au>
References: <20120503125611.4314.52231.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503125611.4314.52231.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 09:56:11PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> This is V1 of the Emma Mobile STI timer driver.
> 
> The STI hardware is based on a single 48-bit 32kHz
> counter that together with two individual compare
> registers can generate interrupts. There are no
> timer operating modes selectable which means that
> the timer can not clear on match.
> 
> This driver is providing clocksource support for the
> 48-bit counter. Clockevents are also supported using
> the same timer in periodic or oneshot modes.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

Tested-by: Simon Horman <horms@verge.net.au>
