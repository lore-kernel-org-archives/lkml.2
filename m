Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1LLDdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:33:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34590 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab1LLDdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:33:12 -0500
Message-ID: <4EE575E3.7090206@zytor.com>
Date: Sun, 11 Dec 2011 19:32:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
References: <1323648762-2148-1-git-send-email-keithp@keithp.com> <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com> <867h22jwj1.fsf@sumi.keithp.com>
In-Reply-To: <867h22jwj1.fsf@sumi.keithp.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2011 07:31 PM, Keith Packard wrote:
> 
> I've got an ancient kernel config that has been culted along for
> several years; I do build a ton of useless modules, but I boot
> without an initrd, so it seems like there shouldn't be many
> differences by the time this crashes.
> 

Could you share your configuration, please?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

