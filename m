Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762426Ab2EQW5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:57:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38281 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760557Ab2EQW5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:57:51 -0400
Message-ID: <4FB58263.30700@zytor.com>
Date: Thu, 17 May 2012 15:57:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H.J. Lu" <hjl.tools@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 01/10] Use __kernel_long_t in struct timex
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <1337292816-10839-2-git-send-email-hjl.tools@gmail.com> <CA+55aFx98qvVg1JhMV0JjgNGb++xtir5ocseY3xgQNc3qAtWdQ@mail.gmail.com> <4FB57EB2.4050208@zytor.com> <CA+55aFzztct_HzmGiit=9SwwM4_YPuXbjwMdJpM1JHMXGBNqaA@mail.gmail.com> <CA+55aFxAY5FvJOjr9=W=g7WDj_gNwKrEeCFAiY2L2YmpaDx1cw@mail.gmail.com>
In-Reply-To: <CA+55aFxAY5FvJOjr9=W=g7WDj_gNwKrEeCFAiY2L2YmpaDx1cw@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 03:56 PM, Linus Torvalds wrote:
> 
> It would make much more sense to use "__word" for reasons like that.
> But I really don't think that works well in a x86 context.
> 
> Other ideas? Maybe "__wordsize" would be less associated with x86 16-bit words?
> 

__[su]native maybe?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

