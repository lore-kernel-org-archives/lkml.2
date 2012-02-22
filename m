Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2BVTT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 14:19:56 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49094 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab2BVTTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 14:19:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ccross@google.com designates 10.50.57.234 as permitted sender) smtp.mail=ccross@google.com; dkim=pass header.i=ccross@google.com
MIME-Version: 1.0
In-Reply-To: <CAOesGMi=nsKr91uu=QTpJ_vKKhc9GBRHPWd6XEB+rOqph_P+yA@mail.gmail.com>
References: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
	<1328831277-21002-3-git-send-email-pdeschrijver@nvidia.com>
	<CAMbhsRT-ZTh7WQ1E0NUjX8FOMGAvx5zNnB-VYD=j8sWhM-9j+A@mail.gmail.com>
	<CAOesGMi=nsKr91uu=QTpJ_vKKhc9GBRHPWd6XEB+rOqph_P+yA@mail.gmail.com>
Date: Wed, 22 Feb 2012 11:19:53 -0800
X-Google-Sender-Auth: 1IjlasUR8-DfKifJVuVoFJ0QgqQ
Message-ID: <CAMbhsRScEnZQrO3Ufrop+Me_ZKoZ=Cd7HqeAdDUOTe2dLPEjiQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/10] ARM: tegra: export Tegra chipid
From: Colin Cross <ccross@android.com>
To: Olof Johansson <olof@lixom.net>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 3:30 PM, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
> On Mon, Feb 20, 2012 at 3:13 PM, Colin Cross <ccross@android.com> wrote:
>
>> Other platforms use accessors for this (cpu_is_xxx(), although
>> soc_is_xxx() is probably more appropriate).
>
> I have previously objected to additions of said functions on tegra,
> since they tend to start crawling into drivers as runtime tests
> instead of providing more appropriate detection at probe time.
>
> I can be persuaded differently but I haven't yet seen a strong case
> for changing my mind. :)

soc_is_xxx() is better than spreading tegra_chip_id == XXX all over
the place, but keeping them out of drivers completely is even better.
