Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2HGMVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:21:10 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58444 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab2HGMVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:21:08 -0400
MIME-Version: 1.0
In-Reply-To: <1343549498-2217-1-git-send-email-develkernel412222@gmail.com>
References: <1343549498-2217-1-git-send-email-develkernel412222@gmail.com>
Date: Tue, 7 Aug 2012 14:21:08 +0200
Message-ID: <CACRpkdY8zD_14CTGjhXhNMhpb=e5ZJU53xd00=4gQgfZn0WJ=A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl-sirf: remove devm_kfree at error path
From: Linus Walleij <linus.walleij@linaro.org>
To: Devendra Naga <develkernel412222@gmail.com>,
        Barry Song <Baohua.Song@csr.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 10:11 AM, Devendra Naga
<develkernel412222@gmail.com> wrote:

> the pointers that are allocated with devm_kzalloc will be automatically freed,
> at unload time.
>
> Signed-off-by: Devendra Naga <develkernel412222@gmail.com>

Applied, Barry if you don't like this, shout now :-)

Yours,
Linus Walleij
