Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab2FDANi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 20:13:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42144 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab2FDANh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 20:13:37 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <201206032130.34509.heiko@sntech.de>
References: <201206032129.45414.heiko@sntech.de> <201206032130.34509.heiko@sntech.de>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 4 Jun 2012 08:13:16 +0800
Message-ID: <CAF+7xWnPNZWD=oTzLecfY5=seHvqeKVVaeDWoK3CE3BG2+O+Sw@mail.gmail.com>
Subject: Re: [PATCH 1/3] regulator: gpio-regulator: do not pass drvdata
 pointer as reference
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/4 Heiko Stübner <heiko@sntech.de>:
> Commit c172708d38a4 (regulator: core: Use a struct to pass in
> regulator runtime configuration) added the drvdata pointer
> only per reference to the new config array in the gpio-regulator.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Axel Lin <axel.lin@gmail.com>
