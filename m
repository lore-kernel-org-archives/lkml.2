Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab1HNHCB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 03:02:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44871 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1HNHB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 03:01:58 -0400
MIME-Version: 1.0
X-Originating-IP: [81.235.222.155]
In-Reply-To: <1313189697-21287-6-git-send-email-swarren@nvidia.com>
References: <1313189697-21287-1-git-send-email-swarren@nvidia.com>
	<1313189697-21287-6-git-send-email-swarren@nvidia.com>
Date: Sun, 14 Aug 2011 00:01:57 -0700
Message-ID: <CAOesGMj8firxDz-kqkh=jwsbC_QRW+YSFpf7dh3WaOhseCg91w@mail.gmail.com>
Subject: Re: [RFC PATCH 05/12] arm/dt: Tegra: Add nvidia,gpios property to
 GPIO controller
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 3:54 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Add board-specific gpio node for Harmony and Seaboard. This lists the
> GPIOs used by the board. Note that not all GPIOs that exist on the board
> are listed; only those used by devices currently supported by device
> tree.


I don't want to bikeshed over this, but something like
"nvidia,enabled-gpios" could be a bit more descriptive. Either way is
OK though.

The property should be documented under the bindings Documentation/
hierarchy though.


-Olof
