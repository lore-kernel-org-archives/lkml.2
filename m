Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab2IZLP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:15:57 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51316 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab2IZLP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:15:56 -0400
MIME-Version: 1.0
In-Reply-To: <1348557100-16972-1-git-send-email-sachin.kamat@linaro.org>
References: <1348557100-16972-1-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 26 Sep 2012 13:15:56 +0200
Message-ID: <CACRpkdbG=a-dZD5UdTJAt1Jy=-DRaZm9y-fryWCN_5-v+i1o6g@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Fix potential memory leak in pinctrl_register_one_pin()
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 9:11 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> 'pindesc' was not freed when returning from an error induced
> exit path.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Thanks, patch applied!
Linus Walleij
