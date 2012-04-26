Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab2DZVMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:12:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58433 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2DZVMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:12:31 -0400
MIME-Version: 1.0
In-Reply-To: <1335451631-17826-1-git-send-email-blogic@openwrt.org>
References: <1335451631-17826-1-git-send-email-blogic@openwrt.org>
Date: Thu, 26 Apr 2012 23:12:30 +0200
Message-ID: <CACRpkdYXtPKQz2hKkm4C=b5N8Dg4ioH94T-QQLorVFPmF8sRZw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: enhance reporting of errors when loading from DT
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 4:47 PM, John Crispin <blogic@openwrt.org> wrote:

> There are a few places in the api where the code simply returns -EINVAL when
> it finds an error. An example is pinmux_map_to_setting() which now reports an
> error if we try to match a group with a function that it does not support.
>
> The reporting of errors in pinconf_check_ops and pinmux_check_ops now has the
> same style and is located inside the according functions and not the calling
> code.
>
> When the map is found in the DT but the default state can not be selected we
> get an error to know that the code at least tried.
>
> The patch also removes a stray word from one comment and a "->" from another
> for the sake of consistency.
>
> Finally we replace a few pr_err/debug() calls with dev_err/dbg().
>
> Thanks go to Stephen Warren for reviewing the patch and enhancing the reporting
> inside pinmux_map_to_setting().
>
> Signed-off-by: John Crispin <blogic@openwrt.org>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: linux-kernel@vger.kernel.org

Thanks, applied with Stephens ACK.

Yours,
Linus Walleij
