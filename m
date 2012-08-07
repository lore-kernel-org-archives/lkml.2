Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab2HGGhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 02:37:08 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49920 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2HGGhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 02:37:05 -0400
MIME-Version: 1.0
In-Reply-To: <F45880696056844FA6A73F415B568C695B0E6E71EE@EXDCVYMBSTM006.EQ1STM.local>
References: <1343651301-5526-1-git-send-email-arun.murthy@stericsson.com>
	<F45880696056844FA6A73F415B568C695B0E6E71EE@EXDCVYMBSTM006.EQ1STM.local>
Date: Tue, 7 Aug 2012 08:37:04 +0200
Message-ID: <CACRpkdaeHfKg3v_Xe-08iVn5W=GTKuNJo1Gw=FO4xSBPvoUR6w@mail.gmail.com>
Subject: Re: [PATCH 0/4] modem_shm: U8500 SHaRed Memory driver(SHRM)
From: Linus Walleij <linus.walleij@linaro.org>
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 6:36 AM, Arun MURTHY <arun.murthy@stericsson.com> wrote:

> Any Comments?

Since the modem is quite close to the networking stack, maybe it should be
cross-posted to the netdev list on next iteration:
http://vger.kernel.org/vger-lists.html#netdev

The code itself I think I've read so many times that I'm now unable to
see any remaining mistakes...

Yours,
Linus Walleij
