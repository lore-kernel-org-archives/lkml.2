Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1IUUR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:17:57 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34944 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab1IUURz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:17:55 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <1316633620-13184-2-git-send-email-swarren@nvidia.com>
References: <1316633620-13184-1-git-send-email-swarren@nvidia.com>
	<1316633620-13184-2-git-send-email-swarren@nvidia.com>
Date: Wed, 21 Sep 2011 13:17:55 -0700
Message-ID: <CAOesGMgLjABKExDWUdtW6zVsKmHQpw7-7bcTHCf9ip1auw7OoQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] arm/tegra: Replace <mach/gpio.h> with <mach/gpio-tegra.h>
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
> This will eventually allow <mach/gpio.h> to be deleted. This mirrors
> LinusW's recent equivalent work on various other ARM platforms.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Olof Johansson <olof@lixom.net>
