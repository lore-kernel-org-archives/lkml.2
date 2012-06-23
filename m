Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab2FWQRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 12:17:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43094 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755467Ab2FWQRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 12:17:23 -0400
References: <CAMe9rOqPfy3JcZRLaUeCjBe9BVY-P6e0uaSbMi5hvS-6WwQueg@mail.gmail.com> <20120623161324.GS11413@one.firstfloor.org>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120623161324.GS11413@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: PATCH] Use -mpreferred-stack-boundary=3 on x86-64 if supported
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 23 Jun 2012 09:17:06 -0700
To: Andi Kleen <andi@firstfloor.org>, "H.J. Lu" <hjl.tools@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Message-ID: <24bd04a1-1702-4d57-af64-af2381992789@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To keep gcc from paddong the stack to maintain a nonexistent alignment.

Andi Kleen <andi@firstfloor.org> wrote:

>> This patch uses -mpreferred-stack-boundary=3 on x86-64 if it is
>supported.
>> I have been running 3.4 kernel compiled with this option for weeks.
>
>But why? 
>
>All the SSE code in the kernel should adjust manually. And the other
>code doesn't need it.
>
>Besides the entry points do not guarantee alignment.
>
>For the kernel it would be probably more useful to have a attribute
>per function that forces alignment.
>
>-Andi
>-- 
>ak@linux.intel.com -- Speaking for myself only.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
