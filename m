Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab1LLMjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 07:39:54 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41929 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab1LLMjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 07:39:53 -0500
MIME-Version: 1.0
In-Reply-To: <1323475145-26430-1-git-send-email-swarren@nvidia.com>
References: <1323475145-26430-1-git-send-email-swarren@nvidia.com>
Date: Mon, 12 Dec 2011 13:39:52 +0100
Message-ID: <CACRpkdY=9ex2bSUC8ZscQ7t_xAK2TvCxMVajdQXoHZTZNRM9qQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: Implement PINMUX_MAP_SYS_HOG
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 12:59 AM, Stephen Warren <swarren@nvidia.com> wrote:

> This is the same as PINMUX_MAP_PRIMARY_SYS_HOG, except that it allows
> you to specify a particular control device.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Looks like a good idea, applied.

Linus Walleij
