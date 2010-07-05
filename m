Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab0GEI2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:28:22 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:55313 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0GEI2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:28:21 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX181Csn+wAcrq4cHF4bOBORd
Date: Mon, 5 Jul 2010 11:28:12 +0300
From: Tony Lindgren <tony@atomide.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tero Kristo <tero.kristo@nokia.com>,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Magnus Damm <damm@igel.co.jp>, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 13/33] Replacing LEDS_OMAP_DEBUG with OMAP_DEBUG_LEDS
Message-ID: <20100705082810.GG15951@atomide.com>
References: <cover.1277911345.git.siccegge@cs.fau.de>
 <b1363abf63cf2e35450acae82765ba679f1979bc.1277911346.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1363abf63cf2e35450acae82765ba679f1979bc.1277911346.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Egger <siccegge@cs.fau.de> [100630 18:58]:
> LEDS_OMAP_DEBUG doesn't exist in Kconfig, therefore replacing all
> references for it with OMAP_DEBUG_LEDS from the source code.

Applied.

Tony
