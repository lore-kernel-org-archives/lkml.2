Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab2LPLki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 06:40:38 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:48549 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab2LPLkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 06:40:37 -0500
MIME-Version: 1.0
In-Reply-To: <1353403339-11679-3-git-send-email-dmitry.torokhov@gmail.com>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
	<1353403339-11679-3-git-send-email-dmitry.torokhov@gmail.com>
Date: Sun, 16 Dec 2012 17:10:36 +0530
Message-ID: <CAKohpomA=vSGuKfD-_zwiSnXGkqAQjtiVqxT2Po=D-LDA_FESg@mail.gmail.com>
Subject: Re: [PATCH 2/3] CLK: uninline clk_prepare_enable() and clk_disable_unprepare()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mike Turquette <mturquette@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2012 14:52, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> We'll need to invoke clk_disable_unprepare() via a pointer in our devm_*
> conversion so let's uninline the pair.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Mike, are you taking these patches?
