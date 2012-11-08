Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab2KHVei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:34:38 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36720 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab2KHVeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:34:37 -0500
MIME-Version: 1.0
In-Reply-To: <1352342724.19098.2.camel@phoenix>
References: <1352342724.19098.2.camel@phoenix>
Date: Thu, 8 Nov 2012 22:34:36 +0100
Message-ID: <CACRpkdYYjg1FgwdbBvhokiJAuZPge8wquYKD+OQViztCm+-=UA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: tegra: Staticize non-exported symbols
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 3:45 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Both tegra_gpio_request() and tegra_gpio_free() are not referenced outside of
> this file, make them static.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied with Stephen's ACK.

Yours,
Linus Walleij
