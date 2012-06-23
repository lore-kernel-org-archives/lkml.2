Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2FWTqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 15:46:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44311 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755775Ab2FWTqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 15:46:16 -0400
References: <CAMe9rOqPfy3JcZRLaUeCjBe9BVY-P6e0uaSbMi5hvS-6WwQueg@mail.gmail.com> <20120623161324.GS11413@one.firstfloor.org> <24bd04a1-1702-4d57-af64-af2381992789@email.android.com> <20120623192704.GT11413@one.firstfloor.org>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120623192704.GT11413@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: PATCH] Use -mpreferred-stack-boundary=3 on x86-64 if supported
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 23 Jun 2012 12:45:57 -0700
To: Andi Kleen <andi@firstfloor.org>
CC: "H.J. Lu" <hjl.tools@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <7d9b7b08-77e8-4757-b8fb-f42ba53bded4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, it didn't work on 64 bits until now.

Andi Kleen <andi@firstfloor.org> wrote:

>On Sat, Jun 23, 2012 at 09:17:06AM -0700, H. Peter Anvin wrote:
>> To keep gcc from paddong the stack to maintain a nonexistent
>alignment.
>
>
>Ah ok. 3 instead of 4.
>
>I thought i had done that a long time ago, but now it somehow
>only seems to be there for 32bit.
>
>Makes sense.
>
>-Andi

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
