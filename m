Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab1LLDCK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:02:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34435 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab1LLDCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:02:07 -0500
Message-ID: <4EE56E99.60801@zytor.com>
Date: Sun, 11 Dec 2011 19:01:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
References: <1323648762-2148-1-git-send-email-keithp@keithp.com> <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com>
In-Reply-To: <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2011 06:59 PM, Linus Torvalds wrote:
> On Sun, Dec 11, 2011 at 4:12 PM, Keith Packard <keithp@keithp.com> wrote:
>> This hangs my MacBook Air at boot time; I get no console messages at
>> all. I reverted this on top of -rc5 and my machine boots again.
> 
> Interesting. Current -git works for me on my 11" Macbook Air. Which
> should be identical to yours. This is the 4GB RAM, 128GB disk version,
> no?
> 
> But I'm running OpenSUSE, and you're running Debian, right? And our
> kernel configs are probably wildly different, since I tend to try to
> boot a fairly minimal set.
> 
> That said, if you've verified that if fails for you, I guess we should
> revert regardless. Matt, any suggestions for tests to do?
> 

Also... I'd like to know what machines, if any, would break without the
patch, so we can figure out what has to be tested.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

