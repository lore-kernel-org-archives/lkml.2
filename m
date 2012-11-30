Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386Ab2K3Q7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:59:35 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:58740 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab2K3Q7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:59:34 -0500
Message-ID: <50B8E5ED.3000805@free-electrons.com>
Date: Fri, 30 Nov 2012 17:59:25 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>,
        Andres Salomon <dilinger@queued.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] clocksource: use clockevents_config_and_register() where
 possible
References: <1353936700-15255-1-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1353936700-15255-1-git-send-email-shawn.guo@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 26/11/2012 14:31, Shawn Guo a écrit :
> The clockevent core is able to figure out the best mult and shift,
> calculate min_delta_ns and max_delta_ns, with the necessary info passed
> into clockevents_config_and_register().  Use this combined configure
> and register function where possible to make the codes less error prone
> and gain some positive diff stat.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
