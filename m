Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab2KMONK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:13:10 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36264 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769Ab2KMONI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:13:08 -0500
MIME-Version: 1.0
In-Reply-To: <1352685716.4984.2.camel@phoenix>
References: <1352685622.4984.0.camel@phoenix>
	<1352685716.4984.2.camel@phoenix>
Date: Tue, 13 Nov 2012 15:13:06 +0100
Message-ID: <CACRpkdb-0aHs0pGmO9vUUueswMssjxuH=fXg=3SuQ-vS1tnimw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] pinctrl: mxs: Make PINCTRL_MXS select PINMUX && PINCONF
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Dong Aisheng <dong.aisheng@linaro.org>,
        Devendra Naga <devendra.aaru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 3:01 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Then we can remove "select PINMUX && PINCONF" from PINCTRL_IMX{23,28}.
> This simplifies the dependency.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>

Patch applied (unless Shawn get upset).

Yours,
Linus Walleij
