Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2BTXaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 18:30:15 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49173 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab2BTXaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 18:30:12 -0500
MIME-Version: 1.0
X-Originating-IP: [207.239.114.206]
In-Reply-To: <CAMbhsRT-ZTh7WQ1E0NUjX8FOMGAvx5zNnB-VYD=j8sWhM-9j+A@mail.gmail.com>
References: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
	<1328831277-21002-3-git-send-email-pdeschrijver@nvidia.com>
	<CAMbhsRT-ZTh7WQ1E0NUjX8FOMGAvx5zNnB-VYD=j8sWhM-9j+A@mail.gmail.com>
Date: Mon, 20 Feb 2012 15:30:11 -0800
Message-ID: <CAOesGMi=nsKr91uu=QTpJ_vKKhc9GBRHPWd6XEB+rOqph_P+yA@mail.gmail.com>
Subject: Re: [PATCH v3 02/10] ARM: tegra: export Tegra chipid
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 20, 2012 at 3:13 PM, Colin Cross <ccross@android.com> wrote:

> Other platforms use accessors for this (cpu_is_xxx(), although
> soc_is_xxx() is probably more appropriate).

I have previously objected to additions of said functions on tegra,
since they tend to start crawling into drivers as runtime tests
instead of providing more appropriate detection at probe time.

I can be persuaded differently but I haven't yet seen a strong case
for changing my mind. :)


-Olof
