Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab1BUEJN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:09:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64212 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab1BUEJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:09:09 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298154371-5641-9-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-9-git-send-email-ccross@android.com>
Date: Sun, 20 Feb 2011 20:09:07 -0800
Message-ID: <AANLkTikTm1EKh87e274mehu+KcURCdMRN5abvHSX3qMY@mail.gmail.com>
Subject: Re: [PATCH v2 07/21] ARM: tegra: clock: Drop CPU dvfs
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 2:25 PM, Colin Cross <ccross@android.com> wrote:
> The existing version did not extend well to core dvfs, drop it
> for now until the new clk api with clk_prepare and clk_unprepare
> is ready and non-atomic clocks are possible.
>
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Olof Johansson <olof@lixom.net>
