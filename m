Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab2FLLb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:31:27 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62144 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab2FLLb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:31:26 -0400
MIME-Version: 1.0
In-Reply-To: <1339243283-28068-1-git-send-email-devendra.aaru@gmail.com>
References: <1339243283-28068-1-git-send-email-devendra.aaru@gmail.com>
Date: Tue, 12 Jun 2012 13:31:25 +0200
Message-ID: <CACRpkdb+GwB_VxfmPSwfc-1BfCs+fePSqnN3binY0xttb5p7xA@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: pinctrl-mxs: Take care of frees if the
 kzalloc fails
From: Linus Walleij <linus.walleij@linaro.org>
To: Devendra Naga <devendra.aaru@gmail.com>,
        Dong Aisheng <B29396@freescale.com>, Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 9, 2012 at 2:01 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:

> if there is no purecfg , the group pointer is allocated using kzalloc and if it
> fails to allocate, we wont free the new_map,
>
> if config is true, we call kmemdup and if it
> fails to do so we wont free the allocated group if there is no purecfg.
>
> fix this by doing the frees of new_map pointer and group pointers.
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

Obviously correct so applied.

Dong, Shawn: any ACKs?

Yours,
Linus Walleij
