Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab1FJHTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 03:19:22 -0400
Received: from ixqw-mail-out.ixiacom.com ([66.77.12.12]:1986 "EHLO
	ixqw-mail-out.ixiacom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab1FJHTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 03:19:21 -0400
Message-ID: <4DF1C55A.2080803@ixiacom.com>
Date: Fri, 10 Jun 2011 10:18:50 +0300
From: Daniel Baluta <dbaluta@ixiacom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Maxin B John <maxin.john@gmail.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>
CC: "nux-doc@vger.kernel.org" <nux-doc@vger.kernel.org>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: update kmemleak architecture support info
References: <20110610070937.GA2802@maxin>
In-Reply-To: <20110610070937.GA2802@maxin>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 10:09 AM, Maxin B John wrote:
> -Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze and tile.
> +Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze, tile,
> +s390 and mips.Please check DEBUG_KMEMLEAK dependencies in lib/Kconfig.debug
> +for supported platforms.
The point of adding my generic comment was to remove direct
references to supported platforms.

In this case your patch should remove the line specifying supported
platforms (x86, arm, powerpc, etc) and only add the line pointing
the reader to lib/Kconfig.debug.

When a new platform will be supported lib/Kconfig.debug will
be surely modified, and the change will be consistent with
information in kmemleak.txt.

Cătălin, what do you think?

thanks,
Daniel.
