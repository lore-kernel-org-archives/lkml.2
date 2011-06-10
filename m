Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab1FJOz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 10:55:28 -0400
Received: from service87.mimecast.com ([94.185.240.25]:35645 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756279Ab1FJOz0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 10:55:26 -0400
Date: Fri, 10 Jun 2011 15:55:18 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Daniel Baluta <dbaluta@ixiacom.com>
Cc: Maxin B John <maxin.john@gmail.com>,
        "nux-doc@vger.kernel.org" <nux-doc@vger.kernel.org>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: update kmemleak architecture support
 info
Message-ID: <20110610145518.GD18133@e102109-lin.cambridge.arm.com>
References: <20110610070937.GA2802@maxin>
 <4DF1C55A.2080803@ixiacom.com>
MIME-Version: 1.0
In-Reply-To: <4DF1C55A.2080803@ixiacom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Jun 2011 14:55:53.0094 (UTC) FILETIME=[7EA3FA60:01CC277E]
X-MC-Unique: 111061015552204101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 08:18:50AM +0100, Daniel Baluta wrote:
> On 06/10/2011 10:09 AM, Maxin B John wrote:
> > -Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze and tile.
> > +Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze, tile,
> > +s390 and mips.Please check DEBUG_KMEMLEAK dependencies in lib/Kconfig.debug
> > +for supported platforms.
> The point of adding my generic comment was to remove direct
> references to supported platforms.
> 
> In this case your patch should remove the line specifying supported
> platforms (x86, arm, powerpc, etc) and only add the line pointing
> the reader to lib/Kconfig.debug.
> 
> When a new platform will be supported lib/Kconfig.debug will
> be surely modified, and the change will be consistent with
> information in kmemleak.txt.

I think Daniel's suggestion is better, we don't have to worry about
changing the documentation every time we add a new architecture.

In addition to that, I would say "supported architectures" rather than
platforms.

Thanks.

-- 
Catalin

