Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab2DPJHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:07:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33646 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab2DPJG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:06:59 -0400
MIME-Version: 1.0
In-Reply-To: <1334335746-3353-1-git-send-email-swarren@wwwdotorg.org>
References: <1334335746-3353-1-git-send-email-swarren@wwwdotorg.org>
Date: Mon, 16 Apr 2012 11:06:59 +0200
Message-ID: <CACRpkdYOhNQCqp8NJrfiT4uDFjWxGM-gLvTScLuyypd8-xdpng@mail.gmail.com>
Subject: Re: [PATCH V2] pinctrl: allow pctldevs to decode pin config in debugfs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 6:49 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> Add a pinconf op so that pin controller drivers can decode their pin
> config settings for debugfs.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v2: Add kerneldoc for pin_config_config_dbg_show op

Thanks, patch applied.

Yours,
Linus Walleij
