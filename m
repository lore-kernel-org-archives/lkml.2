Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab2BAVtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:49:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38089 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067Ab2BAVtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:49:32 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <CACRpkdZ76PamNGOuhuqNvMx9k6hRR2MD2L7sJnv7nU_A45Yypg@mail.gmail.com>
References: <1327083746-31430-1-git-send-email-swarren@nvidia.com>
	<1327083746-31430-3-git-send-email-swarren@nvidia.com>
	<CACRpkdZ_hBviswq7pXoLozC8gjzvowCBrj9yjw1xJT79b5rtwQ@mail.gmail.com>
	<20120201082011.GK7399@quad.lixom.net>
	<CACRpkdZ76PamNGOuhuqNvMx9k6hRR2MD2L7sJnv7nU_A45Yypg@mail.gmail.com>
Date: Wed, 1 Feb 2012 13:49:32 -0800
Message-ID: <CAOesGMjrj-+kpj9YL+_fAP_91VZEyuCc8prkSHgut8-0xES9Nw@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: tegra: Switch to new pinctrl driver
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 12:11 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Feb 1, 2012 at 9:20 AM, Olof Johansson <olof@lixom.net> wrote:
>
>> This series is:
>> Acked-by: Olof Johansson <olof@lixom.net>
>
> OK that's great!
>
>> can you land this series in a stable branch in
>> your tree that you promise not to rebase between now and upstream
>> submission?
>
> I thinkso, I rebased to some fixes from -rc2 today but no need to
> do that again, there is one bug fix which may end up in both
> mainline and my tree but whatever, git will cope.

Ok, yeah that should be fine. Alternatively, applying only these
patches on a separate branch that you pull into your main for-3.4
branch means that if you have to rebase the rest of for-3.4 you can
get away with it as long as you yet again only pull in this branch
instead of include it in the rebase.

> However I am waiting for Stephen to do some fixes and arrive
> at a final version first.

Sounds good.


-Olof
