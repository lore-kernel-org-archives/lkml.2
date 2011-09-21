Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab1IUKso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 06:48:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41139 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab1IUKsm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 06:48:42 -0400
MIME-Version: 1.0
In-Reply-To: <1316359301-2263-1-git-send-email-linkinjeon@gmail.com>
References: <1316359301-2263-1-git-send-email-linkinjeon@gmail.com>
Date: Wed, 21 Sep 2011 12:48:41 +0200
Message-ID: <CACRpkdaqFG20YU-YmWxj+M4tqrSB=wCN=HX==rFfUJnJTqajiQ@mail.gmail.com>
Subject: Re: [PATCH] mmc : Use wait_for_completion_timeout() instead of
 wait_for_completion in case of write.
From: Linus Walleij <linus.walleij@linaro.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 5:21 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:

> +                       timeout_us += mrq->data->timeout_clks * 1000 /
> +                               (mmc_host_clk_rate(host) / 1000);

The math teacher says this is equivalent to:

timeout_us += (mrq->data->timeout_clks / mmc_host_clk_rate) * 1000000 ;

Yours,
Linus Walleij
