Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654Ab1F1Qj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:39:29 -0400
Received: from 14.98.mail-out.ovh.net ([188.165.39.104]:39534 "EHLO
	98.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756138Ab1F1Qh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:37:27 -0400
Date: Tue, 28 Jun 2011 18:03:17 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        avictor.za@gmail.com
Subject: Re: [PATCH] AT91: add AT91SAM9X5 dummy configuration variable
Message-ID: <20110628160317.GR17355@game.jcrosoft.org>
References: <1309260927-11411-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309260927-11411-1-git-send-email-nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 18358360932146522988
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: Vade Retro 01.322.25 AV+AS Profile: OVH; Bailout: 300; @!Recipients (-100); (-100)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:35 Tue 28 Jun     , Nicolas Ferre wrote:
> Add this Kconfig variable to ease the submission of this chip support.
> As this chip/board inclusion is dealayed due to deep consolidation of
> arm/mach-at91 sources, we include this dummy configuration variable to allow
> submission of SAM9x5 related drivers in other subsystems.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
