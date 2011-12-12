Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1LLRKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:10:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40263 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab1LLRKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:10:10 -0500
Message-ID: <4EE63552.5000704@zytor.com>
Date: Mon, 12 Dec 2011 09:09:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
References: <1323648762-2148-1-git-send-email-keithp@keithp.com>  <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com> <1323684086.3669.16.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1323684086.3669.16.camel@mfleming-mobl1.ger.corp.intel.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 02:01 AM, Matt Fleming wrote:
> 
> At this late -rc stage I agree it makes sense to revert this. The
> CONFIG_X86_32 oops that the patch fixes has been around for years and no
> one seems to have encountered it (until now), whereas this new
> regression is likely to affect many more users.
> 

Agreed on both accounts.

For the revert:

Acked-by: H. Peter Anvin <hpa@zytor.com>

... or we can push it in the next x86/urgent batch.

However, still want to chase the root cause down.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

