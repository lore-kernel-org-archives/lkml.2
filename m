Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab2GJVIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 17:08:41 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53947 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2GJVIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 17:08:40 -0400
MIME-Version: 1.0
In-Reply-To: <4FFB4B5F.30103@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
	<4FF6994B.9040801@linaro.org>
	<20120706173957.GA10202@core.coreip.homeip.net>
	<4FFB288D.4080606@linaro.org>
	<20120709201422.GA12242@core.coreip.homeip.net>
	<4FFB40A4.5060505@linaro.org>
	<20120709204620.GA12692@core.coreip.homeip.net>
	<4FFB463F.9040201@linaro.org>
	<CACRpkdbjkLvD13_g=TvCUYjqhZ7ySOiEL51h9eT3YVMO4Vnr3A@mail.gmail.com>
	<4FFB4B5F.30103@linaro.org>
Date: Tue, 10 Jul 2012 23:08:39 +0200
Message-ID: <CACRpkdYJi3Kk3gpdgFLWr+tun4LZNMw0ET6W2nHJfY5jSvgcjw@mail.gmail.com>
Subject: Re: [PATCH 7/9] Input: ab8500-ponkey: Create AB8500 domain IRQ mapping
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 11:21 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On 09/07/12 23:03, Linus Walleij wrote:

>> Now since I was fooled by the last patch, thinking you had tested it
>> before
>> submitting (obviously not) - please send a test log of some
>> cat /dev/input/event* for this one before I ACK it this time.

(Hm, sorry for grumpy mode...)

> I did test it, but must have only looked at the one IRQ incrementing.

That's not enough, cat /dev/input/event/* whatever event node is used
by the ponkey, press it and verify you get some garbage (=events)
in the console.

Yours,
Linus Walleij
