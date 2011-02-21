Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1BUE3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:29:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57613 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab1BUE3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:29:06 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298154371-5641-23-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-23-git-send-email-ccross@android.com>
Date: Sun, 20 Feb 2011 20:28:54 -0800
Message-ID: <AANLkTikE8wVsuZ0QNZoB0htowSs+xeCa5+ockXH6_TgG@mail.gmail.com>
Subject: Re: [PATCH v2 21/21] ARM: tegra: clock: Miscellaneous clock updates
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 2:26 PM, Colin Cross <ccross@android.com> wrote:
> Correct max rates for pclk and sclk (Originally fixed by
>  Dima Zavin <dima@android.com>)
>
> Correct max rate for plla (Originally fixed by
>  Stephen Warren <swarren@nvidia.com>)
>
> Remove unnecessary no-op set_rate on audio clocks
>
> Add clock lookup entries for grhost, bsea, and vde clocks
>
> Update clock clookup entries for vcp, bsea, and vde clocks
>
> Add shared clock entries for sclk and emc
>
> Add a virtual cop clock to provide a reset op (Originally fixed by
>  Dima Zavin <dima@android.com>)
>
> Pass set_rate on super clocks through to parent
>
> Fix pllx frequency table entry for 608 MHz
>
> Remove incorrect plla frequency table entries
>
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Olof Johansson <olof@lixom.net>
