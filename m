Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab2FGLAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 07:00:45 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56366 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab2FGLAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 07:00:44 -0400
MIME-Version: 1.0
In-Reply-To: <1338656677-3979-1-git-send-email-devendra.aaru@gmail.com>
References: <1338656677-3979-1-git-send-email-devendra.aaru@gmail.com>
Date: Thu, 7 Jun 2012 13:00:43 +0200
Message-ID: <CACRpkdZDvAGcfRuE76YiNwfOoLt77Cr97hf+uWf9VMkERKCp-A@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: free if of_get_parent fails to get the
 parent node
From: Linus Walleij <linus.walleij@linaro.org>
To: Devendra Naga <devendra.aaru@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 2, 2012 at 7:04 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:

> of_get_parent can return null if no parent node found, so the allocated new_map
> should be freed.
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  drivers/pinctrl/pinctrl-imx.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Shawn/Dong can you ACK/NACK this patch so I can apply it to
pinctrl? Alternatively you can push it through the i.MX tree if
need be, Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
