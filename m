Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1HKUyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:54:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:50262 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab1HKUyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:54:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=obYM///egObahfLs7WZFlwq81GxDEnpPFP9yx3Fsq0tBFB9hfULO+q2U0azOG31wZ
	42ZN6fpFGkA9O2Ju78rjw==
MIME-Version: 1.0
In-Reply-To: <1313095404-27858-1-git-send-email-swarren@nvidia.com>
References: <1313095404-27858-1-git-send-email-swarren@nvidia.com>
Date: Thu, 11 Aug 2011 13:54:03 -0700
X-Google-Sender-Auth: 16HhE-Dr1gOwAn4dikL9Ic-Dh0Y
Message-ID: <CAMbhsRRGDAmYv3_EbJ+WVg0C7e3-FFcLCgq4W325ECKX06M6Hg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] gpio/tegra: Remove use of irq_to_gpio
From: Colin Cross <ccross@android.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 1:43 PM, Stephen Warren <swarren@nvidia.com> wrote:
> irq_to_gpio is being removed. Replace the only use of that API by
> the ARM Tegra sub-architecture.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> This series is the irq_to_gpio patches I posted last week, rebased to ToT,
> plus removing Tegra's custom gpio_to_irq.
>
> This series was tested against next-20110811 on Harmony, by playing audio
> and plugging/unplugging headphones. Headphone detection relies on using a
> GPIO as an IRQ, and hence on gpio_to_irq.

This whole series looks good to me:
Acked-by: Colin Cross <ccross@android.com>
