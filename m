Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2FDAPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 20:15:22 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53767 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab2FDAPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 20:15:21 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <201206032132.06209.heiko@sntech.de>
References: <201206032129.45414.heiko@sntech.de> <201206032132.06209.heiko@sntech.de>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 4 Jun 2012 08:15:00 +0800
Message-ID: <CAF+7xWn4Jje+XGpE3R1NfKN8knJHpGeBVaO428Sm_hN9tyDYBg@mail.gmail.com>
Subject: Re: [PATCH 3/3] regulator: gpio-regulator: populate selector from set_voltage
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/4 Heiko Stübner <heiko@sntech.de>:
> This was missing until now and the underlying
> _regulator_do_set_voltage is using this value when calling list_voltage.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Acked-by: Axel Lin <axel.lin@gmail.com>
