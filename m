Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab0ITJ35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 05:29:57 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:41085 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755959Ab0ITJ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 05:29:56 -0400
Message-ID: <4C972975.1000004@stericsson.com>
Date: Mon, 20 Sep 2010 11:29:25 +0200
From: Linus Walleij <linus.walleij@stericsson.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH] RTC: rtc-ab3100 - Add missing platform_set_drvdata()
 in ab3100_rtc_probe()
References: <1284891726.2199.3.camel@phoenix>
In-Reply-To: <1284891726.2199.3.camel@phoenix>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:

> Otherwise, calling platform_get_drvdata() in ab3100_rtc_remove() return NULL.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Ah thanks!

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
