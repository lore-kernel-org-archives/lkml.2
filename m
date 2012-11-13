Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab2KMOFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:05:12 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:60782 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab2KMOFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:05:10 -0500
MIME-Version: 1.0
In-Reply-To: <1352600980.23129.5.camel@phoenix>
References: <1352600980.23129.5.camel@phoenix>
Date: Tue, 13 Nov 2012 15:05:09 +0100
Message-ID: <CACRpkdYhP_Hv7TwrxkBCoSmAiWMB-re1cS-v_hBimxJVfg_DuA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: spear: Staticize non-exported symbols
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2012 at 3:29 AM, Axel Lin <axel.lin@ingics.com> wrote:

> They are not referenced outside of this file, make them static.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied with Viresh's ACK.

Thanks!
Linus Walleij
