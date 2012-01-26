Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2AZVtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:49:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48640 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab2AZVtB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:49:01 -0500
MIME-Version: 1.0
In-Reply-To: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
References: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
Date: Thu, 26 Jan 2012 13:49:00 -0800
X-Google-Sender-Auth: 5dK8WHFWiNzuX7YD16LwxOEwJ6U
Message-ID: <CAMbhsRQips51u_hB0-xMdFsSPCCxsehXiiSVx0D5KZxQRwTT0A@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] Add support for LP3
From: Colin Cross <ccross@android.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 8:22 AM, Peter De Schrijver
<pdeschrijver@nvidia.com> wrote:
> Introduce support for LP3 (CPU core clockgating) for Tegra20 and Tegra30.
>
> Peter De Schrijver (3):
>  ARM: tegra: definitions for flow controller
>  ARM: tegra: assembler code for LP3
>  ARM: tegra: cpuidle driver for tegra
>
>  arch/arm/mach-tegra/Makefile   |    2 +
>  arch/arm/mach-tegra/cpuidle.c  |  107 ++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-tegra/flowctrl.h |   37 ++++++++++++++
>  arch/arm/mach-tegra/sleep.S    |   91 ++++++++++++++++++++++++++++++++++
>  4 files changed, 237 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-tegra/cpuidle.c
>  create mode 100644 arch/arm/mach-tegra/flowctrl.h
>  create mode 100644 arch/arm/mach-tegra/sleep.S

For the series,
Acked-by: Colin Cross <ccross@android.com>
