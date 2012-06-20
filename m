Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab2FTIEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:04:42 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:57130 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab2FTIEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:04:37 -0400
MIME-Version: 1.0
In-Reply-To: <1340041471-30122-1-git-send-email-devendra.aaru@gmail.com>
References: <1340041471-30122-1-git-send-email-devendra.aaru@gmail.com>
Date: Wed, 20 Jun 2012 10:04:36 +0200
Message-ID: <CACRpkdaZzMjWL=hE3wiPJ6m+XtzB-aeWfrr5QFJ8+3PPTbsX4Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl/pinctrl-tegra: remove IS_ERR checking of pmx->pctl
From: Linus Walleij <linus.walleij@linaro.org>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 7:44 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:

> pinctrl_register returns a pointer of struct type struct pinctrl_dev,
> if successfully registered to pinctrl subsystem, otherwise returns
> NULL, and there wont' be any pointers which are not dereferencible.
>
> They are not type of pointer addresses but are kind of error
> codes rather actual addresses, but are a kind of return
> codes of functions returning integer types.
>
> return -ENODEV if device registration fails.
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

Applied with Stephen's ACK, thanks!
Linus Walleij
