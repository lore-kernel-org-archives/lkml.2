Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab1BEEiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 23:38:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47018 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab1BEEiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 23:38:06 -0500
Message-ID: <4D4CD411.6070800@zytor.com>
Date: Fri, 04 Feb 2011 20:37:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, castet.matthieu@free.fr,
        tglx@linutronix.de, hpa@linux.intel.com
Subject: Re: [tip:x86/urgent] x86-32: Make sure the stack is set up before
 we use it
References: <4D41E86D.8060205@free.fr> <tip-43d79a250bdb10e30b08a79e906befc691c3f5ce@git.kernel.org> <20110205021922.GP5503@outflux.net>
In-Reply-To: <20110205021922.GP5503@outflux.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2011 06:19 PM, Kees Cook wrote:
> Hi Peter,
> 
> This works for me doing CPU hotplugging on ia32, but on x86_64 it hangs.
> (Both boot, though.)
> 
> Thanks,
> 
> -Kees

I can't reproduce the failure here, and it's hard to see how this patch
would make a significant change on 64 bits.  Could you try reverting
*only* the head_64.S hunk and try it on your platform again?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

