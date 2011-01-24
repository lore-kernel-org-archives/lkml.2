Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1AXHbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 02:31:19 -0500
Received: from smtp-out.google.com ([216.239.44.51]:32958 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab1AXHbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 02:31:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sUafkiugmSCxnQZJufxXJUGjmVPDffKqvhzeMeUg6fUV4oXBW5p015RcUpM6ChE9Id
         q8obKO0eMJxLJ/VN3+AA==
MIME-Version: 1.0
In-Reply-To: <1295834493-5019-14-git-send-email-ccross@android.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
	<1295834493-5019-14-git-send-email-ccross@android.com>
Date: Sun, 23 Jan 2011 23:31:14 -0800
X-Google-Sender-Auth: kix1faQFXzwyX9kLiMy41GF7Gm4
Message-ID: <AANLkTim9s-ZCGT_2gSYGPvNzGOshzhp5umG_jN3D+oTo@mail.gmail.com>
Subject: Re: [PATCH v2 13/28] ARM: tegra: Add suspend and hotplug support
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>, linux@arm.linux.org.uk,
        Gary King <gking@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 6:01 PM, Colin Cross <ccross@android.com> wrote:

<snip>

> diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
> index 00a6ba3..0bf1441 100644
> --- a/arch/arm/mach-tegra/Makefile
<snip>

> +obj-$(CONFIG_LOCAL_TIMER)               += localtimer.o

This needs to be CONFIG_LOCAL_TIMERS
