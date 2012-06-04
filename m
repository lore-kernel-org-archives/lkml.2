Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab2FDAOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 20:14:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34541 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab2FDAOl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 20:14:41 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <201206032131.09429.heiko@sntech.de>
References: <201206032129.45414.heiko@sntech.de> <201206032131.09429.heiko@sntech.de>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 4 Jun 2012 08:14:20 +0800
Message-ID: <CAF+7xWnntu+Ddat6PrZz0xaqELbdxu9L6aCTyBLSPtFudbcg8g@mail.gmail.com>
Subject: Re: [PATCH 2/3] regulator: gpio-regulator: Fix finding of smallest value
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/4 Heiko Stübner <heiko@sntech.de>:
> Commit 4dbd8f63f07a (regulator: gpio-regulator: Set the smallest
> voltage/current in the specified range) forgot to set the newly
> introduced best_val.
>
> Therefore it stayed always at INT_MAX thus breaking the setting
> of the voltage.
>
> Included is also an init value for target, as warnings about
> a possibly uninitialised target started appearing with this fix.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Acked-by: Axel Lin <axel.lin@gmail.com>
