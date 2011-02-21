Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab1BUEFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:05:33 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46986 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab1BUEFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:05:30 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298154371-5641-3-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-3-git-send-email-ccross@android.com>
Date: Sun, 20 Feb 2011 20:05:29 -0800
Message-ID: <AANLkTimOX62Qm4DsjjevCotj8ULrqYvSm_TuM3gpY2r=@mail.gmail.com>
Subject: Re: [PATCH v2 01/21] ARM: tegra: clock: enable clk reset for
 non-peripheral clocks
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, Dima Zavin <dima@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 2:25 PM, Colin Cross <ccross@android.com> wrote:
> From: Dima Zavin <dima@android.com>
>
> Add a new 'reset' clk op. This can be provided for any clock,
> not just peripherals.
>
> Signed-off-by: Dima Zavin <dima@android.com>
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Olof Johansson <olof@lixom.net>
