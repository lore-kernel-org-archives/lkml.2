Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2AaAf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 19:35:28 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54232 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2AaAf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 19:35:26 -0500
MIME-Version: 1.0
In-Reply-To: <20120130.125219.2077768183344205118.davem@davemloft.net>
References: <1327643159-1302-1-git-send-email-tomoya.rohm@gmail.com>
	<20120130.125219.2077768183344205118.davem@davemloft.net>
Date: Tue, 31 Jan 2012 09:35:26 +0900
Message-ID: <CANKRQniQs95kUhyDeP2V7cyOFE1gyi-ihZufmNoi_SGSXm3MGQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] ethernet/pch_gbe: Change company name OKI
 SEMICONDUCTOR to LAPIS Semiconductor
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: jeffrey.t.kirsher@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David

I can understand your saying.

If I post like below, is this patch acceptable for you ?
+       tristate "OKI/LAPIS SEMICONDUCTOR IOH(ML7223/ML7831) GbE"

BTW, I think need consistency for "Change company/product name" as a
whole of linux.
Because other patches for the same series "change company name" I
posted have already accepted.
e.g.(GPIO, USB device, DMA, UART, I2C)

thanks,
tomoya

2012/1/31 David Miller <davem@davemloft.net>:
>
> Sorry, we're not going to get into this pattern where we move drivers
> around in the tree every time the company that produces the chip
> changes it's name.
>
> If we did this then certain drivers will have moved 5 or more times
> since the beginning of the Linux kernel, and there is nothing to be
> gained from that except confusion.
>
> In fact more valuable thing to do is to refer to both the old and the
> new name, rather than just the new one or just the old one.  Because
> you now have two sets of users, one very large set which is familiar
> with the old name and a smaller set which will only know about the new
> name.
>
> Frankly, I would just leave everything alone except perhaps adding a
> mention of the new name (and not deleting the old name) in the Kconfig
> help text.
