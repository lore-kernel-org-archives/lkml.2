Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab2KTKSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 05:18:39 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:34280 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2KTKSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 05:18:37 -0500
MIME-Version: 1.0
In-Reply-To: <1353403339-11679-3-git-send-email-dmitry.torokhov@gmail.com>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
	<1353403339-11679-3-git-send-email-dmitry.torokhov@gmail.com>
Date: Tue, 20 Nov 2012 15:48:37 +0530
Message-ID: <CAKohpo=doVLTRj7WqPmYOxrscZbHjm1+dUSiZoHAcHUHdthLeg@mail.gmail.com>
Subject: Re: [PATCH 2/3] CLK: uninline clk_prepare_enable() and clk_disable_unprepare()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2012 14:52, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> We'll need to invoke clk_disable_unprepare() via a pointer in our devm_*
> conversion so let's uninline the pair.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

This one matches its expectations :)

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
