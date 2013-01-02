Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab3ABFRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 00:17:17 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51867 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3ABFRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 00:17:12 -0500
MIME-Version: 1.0
In-Reply-To: <50E32C06.5020104@gmail.com>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz>
	<1355852048-23188-7-git-send-email-linux@prisktech.co.nz>
	<50D62BC9.9010706@mvista.com>
	<50E32C06.5020104@gmail.com>
Date: Wed, 2 Jan 2013 08:10:36 +0300
Message-ID: <CA+_b7DK2zbBzbCh15ikEAeGP5h-V9gQ_YcX15O-RNvWxCk8Zfg@mail.gmail.com>
Subject: Re: [PATCH RESEND 6/6] clk: s5p-g2d: Fix incorrect usage of IS_ERR_OR_NULL
From: Dan Carpenter <error27@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Tony Prisk <linux@prisktech.co.nz>, Sergei Shtylyov <sshtylyov@mvista.com>,
        kernel-janitors@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns NULL if CONFIG_HAVE_CLK is disabled.

I told Tony about this but everyone has been gone with end of year
holidays so it hasn't been addressed.

Tony, please fix it so people don't apply these patches until
clk_get() is updated to not return NULL.  It sucks to have to revert
patches.

regards,
dan carpenter
