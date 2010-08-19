Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab0HSWCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 18:02:24 -0400
Received: from relay3.sgi.com ([192.48.152.1]:44359 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751191Ab0HSWCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 18:02:22 -0400
Date: Thu, 19 Aug 2010 17:02:14 -0500
From: Robin Holt <holt@sgi.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Stable Maintainers <stable@kernel.org>
Subject: Re: [Patch] numa:x86_64: Cacheline aliasing makes
 for_each_populated_zone extremely expensive -V2.
Message-ID: <20100819220214.GI3043@sgi.com>
References: <20100818165653.GX3043@sgi.com>
 <20100818183024.GZ3043@sgi.com>
 <20100819173013.GG19773@amd.com>
 <20100819204256.GH3043@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819204256.GH3043@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't think this is stable material. It improves performance and does
> > not fix a bug. But I am not the one to decide this :-)
> 
> The only reason I think it qualifies is we are talking about 0.8% of each
> cpus time.  That means that on the 4096 cpu system, we are dedicating
> the equivalent of 32 cpus to just vmstat_update.  That feels like it

Wrong!  0.08%, not 0.8% and therefore 3.2 cpus, not 32.

Sorry for the confusion,
Robin
