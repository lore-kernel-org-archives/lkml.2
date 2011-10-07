Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935626Ab1JGUgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:36:04 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24327 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935541Ab1JGUf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:35:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=gV1D+q7LHVLeGNJ5BiLWzv5RYKjDk+pVrER5hbWCqp+l/96drLKw9AauOVA6l/5Xe
	4gXiyzOLvDRxc5tqnjpAw==
MIME-Version: 1.0
In-Reply-To: <1318019268-6946-1-git-send-email-olof@lixom.net>
References: <1318019268-6946-1-git-send-email-olof@lixom.net>
Date: Fri, 7 Oct 2011 13:35:52 -0700
X-Google-Sender-Auth: 4xKRw3CyaGn8HCCGck_M6miNzw0
Message-ID: <CAMbhsRQtUEx_oh+WMmcDEqMznWyF4p2g54G6tsa8QVVB+BxwuA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Update tegra maintainer information
From: Colin Cross <ccross@android.com>
To: Olof Johansson <olof@lixom.net>
Cc: torvalds@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Erik Gilling <konkers@android.com>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 1:27 PM, Olof Johansson <olof@lixom.net> wrote:
> A couple of changes to the Tegra maintainership setup:
>
> I'm very glad to bring on Stephen Warren on board as a maintainer. The
> work he has done so far is excellent, and the fact that he works for
> Nvidia means he has long-term interest in the platform.
>
> Erik Gilling did an astounding amount of work on getting things up and
> running but has been a silent partner on the maintainership side for a
> while, and is stepping down. Thanks for your contributions so far, Erik.
>
> Finally, update the git URL since I'll take over running the main repo
> for a while.
>
> Overall maintainership model isn't changing much at this time: We'll all
> three review patches as appropriate, and one of us will collect the main
> repo (me at this time).
>
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: Colin Cross <ccross@android.com>
> Cc: Erik Gilling <konkers@android.com>
> Cc: Stephen Warren <swarren@nvidia.com>
> ---
>  MAINTAINERS |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ace8f9c..5483e0c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6366,10 +6366,10 @@ F:      net/ipv4/tcp_lp.c
>
>  TEGRA SUPPORT
>  M:     Colin Cross <ccross@android.com>
> -M:     Erik Gilling <konkers@android.com>
>  M:     Olof Johansson <olof@lixom.net>
> +M:     Stephen Warren <swarren@nvidia.com>
>  L:     linux-tegra@vger.kernel.org
> -T:     git git://android.git.kernel.org/kernel/tegra.git
> +T:     git git://git.kernel.org/pub/scm/linux/kernel/git/olof/tegra.git
>  S:     Supported
>  F:     arch/arm/mach-tegra

Acked-by: Colin Cross <ccross@android.com>
