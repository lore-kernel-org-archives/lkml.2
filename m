Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab2ECG6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:58:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47471 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab2ECG6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:58:10 -0400
Message-ID: <4FA22C75.6010001@zytor.com>
Date: Wed, 02 May 2012 23:57:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: torvalds@linux-foundation.org, npiggin@gmail.com, jana@saout.de,
        jlbec@evilplan.org, linux-kernel@vger.kernel.org
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
References: <CAPa8GCANv=-c7HsYvDqM+8JqJq6Gr9muxAivU2Ni16x9Ru5EXw@mail.gmail.com> <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com> <4FA227FB.7060709@zytor.com> <20120503.025427.1277785208536786257.davem@davemloft.net>
In-Reply-To: <20120503.025427.1277785208536786257.davem@davemloft.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2012 11:54 PM, David Miller wrote:
>>
>> Can we do the trick of aligning the pointer and ignoring the start?
>> That would allow even architectures that don't have unaligned accesses
>> to work, too.
> 
> Doing that would flub the hash computation.

I guess the shifts would be to expensive?

	-hpa
