Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab2HMOAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:00:51 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48254 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab2HMOAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:00:50 -0400
MIME-Version: 1.0
In-Reply-To: <1344610378-12117-1-git-send-email-richard.genoud@gmail.com>
References: <1344610378-12117-1-git-send-email-richard.genoud@gmail.com>
Date: Mon, 13 Aug 2012 16:00:49 +0200
Message-ID: <CACRpkdaWiwM+iZ8fZMxxnKT5zgYnci6AP172vt991NNw6gJSKg@mail.gmail.com>
Subject: Re: [PATCH] Pinctrl header: trivial: declare struct device
From: Linus Walleij <linus.walleij@linaro.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 4:52 PM, Richard Genoud
<richard.genoud@gmail.com> wrote:

> As struct device is used as a function argument, it should at least be
> declared (device.h is not included).
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>

Applied.

Thanks,
Linus Walleij
