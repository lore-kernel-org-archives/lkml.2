Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab2BAKU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 05:20:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34620 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab2BAKU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 05:20:26 -0500
MIME-Version: 1.0
In-Reply-To: <20120201100327.GB2524@pengutronix.de>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
 <1328004002-24646-2-git-send-email-Barry.Song@csr.com> <20120131101734.GE2471@pengutronix.de>
 <CAGsJ_4wyJ6Wymy4AWoW1eHubZX=W7GT_Fbow9ofXoY1RrcHzgA@mail.gmail.com>
 <20120131113358.GM2471@pengutronix.de> <20120131203455.GG22611@ponder.secretlab.ca>
 <20120131211554.GA28105@pengutronix.de> <CAGsJ_4yJZYHUzr9YerdM5o8grGd6iP51ra4nJkMuOo5Khn95RQ@mail.gmail.com>
 <20120201100327.GB2524@pengutronix.de>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 1 Feb 2012 18:20:04 +0800
Message-ID: <CAGsJ_4z_08hNMuoLeNms-TKoyF8dzQipZ2B6jco6DKMDhgTg1w@mail.gmail.com>
Subject: Re: [PATCH 1/3] platform: add common resource requesting and mapping helper
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, Barry Song <Barry.Song@csr.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Erik Gilling <konkers@google.com>,
        linux-mtd@lists.infradead.org, Barry Song <Baohua.Song@csr.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/1 Wolfram Sang <w.sang@pengutronix.de>:
>
>> i think it makes sense for us to have platform_devm_request_irq() and
>> similar things. i'll take care.
>
> I'll try, too. Then we can compare and learn from that.

well, thanks.

>
>> PS:  as the man maintaining embedded systems of the i2c subsystem,
>> would you comment the CSR i2c driver which has been there waiting for
>> a long time?
>> http://www.spinics.net/lists/linux-i2c/msg07081.html
>
> Relax, you sent that only two days ago.

the v5 is sent two days ago with deleting only one line, v1-v4 has
been there 3 monthes :-)
i was not complaining you haven't sent comments for v5.

>
> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |

-barry
