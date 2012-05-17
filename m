Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030630Ab2EQWu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:50:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38148 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030523Ab2EQWu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:50:26 -0400
Message-ID: <4FB580A3.5010909@kernel.org>
Date: Thu, 17 May 2012 15:50:11 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H.J. Lu" <hjl.tools@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 01/10] Use __kernel_long_t in struct timex
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <1337292816-10839-2-git-send-email-hjl.tools@gmail.com> <CA+55aFx98qvVg1JhMV0JjgNGb++xtir5ocseY3xgQNc3qAtWdQ@mail.gmail.com> <4FB57EB2.4050208@zytor.com>
In-Reply-To: <4FB57EB2.4050208@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 03:41 PM, H. Peter Anvin wrote:
> 
> That being said, this is a lot like the __u* and __s* types which we use
> instead of <stdint.h> for similar reasons.  I don't know if
> __ulong/__slong or __uword/__sword would be better here?
> 

Anyway - Linus, if you have a specific preference let me know and can
fix up these patches as well as the existing users in the kernel.

	-hpa
