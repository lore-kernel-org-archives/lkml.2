Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab2AQI3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:29:30 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:62114 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752343Ab2AQI32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:29:28 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <CANKRQngOHk8vHuaigEiaLZgvwu2MDbOz9c45byFb7eEXurEJ8Q@mail.gmail.com>
References: <1326784710.16397.1.camel@phoenix> <CANKRQngOHk8vHuaigEiaLZgvwu2MDbOz9c45byFb7eEXurEJ8Q@mail.gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 17 Jan 2012 16:29:06 +0800
Message-ID: <CAF+7xWnsnRfPtZfSAj2xqUO7sBfQKmy84S5ma20xRQmTUJuPcg@mail.gmail.com>
Subject: Re: [PATCH] gpio: Add missing spin_lock_init in gpio-ml-ioh driver
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Feng Tang <feng.tang@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/17 Tomoya MORINAGA <tomoya.rohm@gmail.com>:
> Hi Alex
It's Axel :-)

>
> Thank you for your indication.
> gpio-pch also looks having the same issue.
> Could you post the patch for gpio-pch ?
Sure. I'll send the patch soon.
