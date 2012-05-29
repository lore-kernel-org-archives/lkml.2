Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab2E2HVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:21:39 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:50810 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726Ab2E2HVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:21:37 -0400
Message-ID: <1338276092.15008.68.camel@cumari.coelho.fi>
Subject: Re: [PATCH] wlcore: fix undefined symbols when CONFIG_PM is not
 defined
From: Luciano Coelho <coelho@ti.com>
To: Eyal Shapira <eyal@wizery.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 29 May 2012 10:21:32 +0300
In-Reply-To: <1338275703-28103-1-git-send-email-eyal@wizery.com>
References: <CAMuHMdVv+g=+A1HHNmWWcsFBQjRXNNA437V6-g80cYq7zRJ78g@mail.gmail.com>
	 <1338275703-28103-1-git-send-email-eyal@wizery.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 00:15 -0700, Eyal Shapira wrote:
> commit 5063c201d7b799d6cb36d3edfc2c2c3db3b400e5
> "wl12xx: add RX filters ACX commands" breaks the build
> when CONFIG_PM isn't defined:
> 
> ERROR: "wl1271_rx_filter_get_fields_size"
> [drivers/net/wireless/ti/wlcore/wlcore.ko] undefined!
> ERROR: "wl1271_rx_filter_flatten_fields"
> [drivers/net/wireless/ti/wlcore/wlcore.ko] undefined!
> 
> code in drivers/net/wireless/ti/wlcore/acx.c is using these
> functions unconditionally while they are #ifdefed CONFIG_PM.
> Fix it by ifdefing all relevant RX filters code with CONFIG_PM.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> ---

Acked-by: Luciano Coelho <coelho@ti.com>

Thanks, Eyal!

John, can you push this up so it gets applied for 3.5?

-- 
Cheers,
Luca.

