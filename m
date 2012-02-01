Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab2BAHf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:35:27 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50264 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab2BAHfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:35:24 -0500
Date: Tue, 31 Jan 2012 23:35:23 -0800
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] Add support for LP3
Message-ID: <20120201073523.GF7399@quad.lixom.net>
References: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 06:22:00PM +0200, Peter De Schrijver wrote:
> Introduce support for LP3 (CPU core clockgating) for Tegra20 and Tegra30.
> 
> Peter De Schrijver (3):
>   ARM: tegra: definitions for flow controller
>   ARM: tegra: assembler code for LP3
>   ARM: tegra: cpuidle driver for tegra
> 
>  arch/arm/mach-tegra/Makefile   |    2 +
>  arch/arm/mach-tegra/cpuidle.c  |  107 ++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-tegra/flowctrl.h |   37 ++++++++++++++
>  arch/arm/mach-tegra/sleep.S    |   91 ++++++++++++++++++++++++++++++++++
>  4 files changed, 237 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-tegra/cpuidle.c
>  create mode 100644 arch/arm/mach-tegra/flowctrl.h
>  create mode 100644 arch/arm/mach-tegra/sleep.S

Thanks, applied.
