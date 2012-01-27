Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2A0CR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 21:17:27 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40086 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2A0CR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 21:17:26 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <1327594923-21822-2-git-send-email-pdeschrijver@nvidia.com>
References: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
	<1327594923-21822-2-git-send-email-pdeschrijver@nvidia.com>
Date: Thu, 26 Jan 2012 18:17:25 -0800
Message-ID: <CAOesGMghrFvCzyTaLfeF5RB77UUxpzEQj+j5Ega_uzL1SdbrOg@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] ARM: tegra: definitions for flow controller
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 26, 2012 at 8:22 AM, Peter De Schrijver
<pdeschrijver@nvidia.com> wrote:
> Introduce some definitions for the tegra flow contoller. This will be
> used by the code which controls entering and leaving LP3.
>
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Do you expect to use these defines anywhere else than in the sleep.S
in the near future? If not, please just move them over to that file.

-Olof
