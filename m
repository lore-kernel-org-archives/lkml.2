Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab2H0EEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 00:04:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43287 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab2H0EEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 00:04:10 -0400
MIME-Version: 1.0
In-Reply-To: <1345996865-32082-11-git-send-email-Julia.Lawall@lip6.fr>
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
	<1345996865-32082-11-git-send-email-Julia.Lawall@lip6.fr>
Date: Mon, 27 Aug 2012 09:34:09 +0530
X-Google-Sender-Auth: p2lcLjUNXa05lOWw53gTZw3KfOA
Message-ID: <CAOh2x=mMkCR8+Y_sPW8pRcS6fi8k=u_VpEWA0NYiUWqHrLJjCQ@mail.gmail.com>
Subject: Re: [PATCH 10/13] drivers/watchdog/sp805_wdt.c: use
 clk_prepare_enable and clk_disable_unprepare
From: viresh kumar <viresh.kumar@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Wim Van Sebroeck <wim@iguana.be>, kernel-janitors@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 9:31 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
> clk_enable, and clk_disable and clk_unprepare.  They make the code more
> concise, and ensure that clk_unprepare is called when clk_enable fails.
>
> A simplified version of the semantic patch that introduces calls to these
> functions is as follows: (http://coccinelle.lip6.fr/)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
