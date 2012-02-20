Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab2BTUoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:44:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36518 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab2BTUon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:44:43 -0500
Message-ID: <4F42B0A1.9030007@zytor.com>
Date: Mon, 20 Feb 2012 12:44:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, hjl.tools@gmail.com
Subject: Re: [PATCH 06/30] sysinfo: Use explicit types in <linux/sysinfo.h>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <1329696488-16970-7-git-send-email-hpa@zytor.com> <CAMuHMdV2-StqLjnMXk8EDbfMSUik7BWuQ1phNSoUq_D0i_1icQ@mail.gmail.com> <4ae6abe6-b935-4033-a9b6-31fa5f58e3c6@email.android.com> <CAMuHMdXyhcZY3zaKGpvT9hE=4tp8UFr1HmQjEz4F=NiYeFcLsA@mail.gmail.com>
In-Reply-To: <CAMuHMdXyhcZY3zaKGpvT9hE=4tp8UFr1HmQjEz4F=NiYeFcLsA@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 12:01 PM, Geert Uytterhoeven wrote:
> On Mon, Feb 20, 2012 at 18:29, H. Peter Anvin <hpa@zytor.com> wrote:
>> Not really... it comes down to "implicit padding in kernel ABI structures is bad".  They can easily become security holes.
> 
> On 64-bit platforms with natural alignment of long, there's an implicit padding.
> 

We should try to make those explicit, but it sometimes gets hard
retroactively.  Note that the particular patch you're pointing to is
just an identity patch.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

