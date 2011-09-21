Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1IUUQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:16:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49571 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab1IUUQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:16:50 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <1316633620-13184-1-git-send-email-swarren@nvidia.com>
References: <1316633620-13184-1-git-send-email-swarren@nvidia.com>
Date: Wed, 21 Sep 2011 13:16:49 -0700
Message-ID: <CAOesGMisOtEQpcS-hHi-3brpYzJr-UiB6b71c+bwkesPDk9iuA@mail.gmail.com>
Subject: Re: [PATCH 1/3] arm/tegra: Move EN_VDD_1V05_GPIO to board-harmony.h
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        Grant Likely <grant.likely@secretlab.ca>, Chris Ball <cjb@laptop.org>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 12:33 PM, Stephen Warren <swarren@nvidia.com> wrote:
> This centralizes all GPIO naming in one header.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Olof Johansson <olof@lixom.net>

> ---
> This patch series relies on various previous changes to the Tegra GPIO
> driver that were made in Russell's GPIO tree. I assume this series will
> go in through that tree.
>
> This first patch is cleanup which makes the second slightly cleaner (no
> need to edit board-harmony-pcie.c in patch 2). Usually, it would go in
> through the Tegra tree, but I think it makes sense to merge these 3
> patches all together in one place.

Works for me. Or I could stage it in a topic branch that would be
merged after Russell's GPIO tree.

Russell, Arnd, got any preferences for one or the other?


-Olof
