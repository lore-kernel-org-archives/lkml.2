Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743Ab1BVFah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 00:30:37 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64222 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab1BVFag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 00:30:36 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1298342392-21236-5-git-send-email-ccross@android.com>
References: <1298342392-21236-1-git-send-email-ccross@android.com>
	<1298342392-21236-5-git-send-email-ccross@android.com>
Date: Mon, 21 Feb 2011 21:30:34 -0800
Message-ID: <AANLkTi=WF_i46ONPf9N+=qdZA0mkP4P4QQO79Amb54CD@mail.gmail.com>
Subject: Re: [PATCH 4/7] ARM: tegra: Move tegra_common_init to tegra_init_early
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, konkers@android.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mike@compulab.co.il, Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 6:39 PM, Colin Cross <ccross@android.com> wrote:
> Move tegra_common_init to tegra_init_early, and set it
> as the init_early entry in the machine struct.
> Initializes the clocks earlier so that timers can enable
> their clocks.
>
> Also reorders the members in the Harmony and Trimslice
> boards' machine structs to match the order they are
> called in.
>
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Olof Johansson <olof@lixom.net>

Please push this ASAP so I can rebase my series, even if some of the
others might need respin. :)


-Olof
