Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab2DJIZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:25:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60543 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134Ab2DJIZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:25:07 -0400
MIME-Version: 1.0
In-Reply-To: <1333553270-9040-5-git-send-email-swarren@wwwdotorg.org>
References: <1333553270-9040-1-git-send-email-swarren@wwwdotorg.org>
	<1333553270-9040-5-git-send-email-swarren@wwwdotorg.org>
Date: Tue, 10 Apr 2012 10:25:06 +0200
Message-ID: <CACRpkdZzET9OKC8xoXV_4OBAd9-EuhSh-OfG=es56bKidCoe9Q@mail.gmail.com>
Subject: Re: [PATCH V4 REPOST 5/5] pinctrl: tegra: Add complete device tree support
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 5:27 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> From: Stephen Warren <swarren@nvidia.com>
>
> Implement pinctrl_ops dt_node_to_map() and dt_free_map(). These allow
> complete specification of the desired pinmux configuration using device
> tree.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
> v3: Rebase on of_property_for_each_string() API changes.
>    Improve DT parsing so it only calls krealloc() on the top-level map
>    table once per subnode, rather than once per subnode/pin combination.
> v2: Rebase on of_property_for_each_string() API changes.

Applied to pinctrl, thanks!
Linus Walleij
