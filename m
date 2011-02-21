Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab1BUEHz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:07:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55088 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab1BUEHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:07:54 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298154371-5641-6-git-send-email-ccross@android.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-6-git-send-email-ccross@android.com>
Date: Sun, 20 Feb 2011 20:07:52 -0800
Message-ID: <AANLkTikWeiv-5cLFo3UG3yLpiPB3=YWQ+-2UV_vfROfF@mail.gmail.com>
Subject: Re: [PATCH v2 04/21] ARM: tegra: clock: Don't use PLL lock bits
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
> The PLL lock bits are not reliable, use per-PLL timeouts instead.
>
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Olof Johansson <olof@lixom.net>
