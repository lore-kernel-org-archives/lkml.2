Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab2DXRRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:17:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35878 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594Ab2DXRRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:17:35 -0400
Message-ID: <4F96E01E.6040109@zytor.com>
Date: Tue, 24 Apr 2012 10:17:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 3/3] math128, x86_64: Implement {mult,add}_u128 in
 64bit asm
References: <20120424161039.293018424@chello.nl>  <20120424162224.588822231@chello.nl> <4F96D604.5050709@zytor.com> <1335285395.28150.204.camel@twins>
In-Reply-To: <1335285395.28150.204.camel@twins>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 09:36 AM, Peter Zijlstra wrote:
> On Tue, 2012-04-24 at 09:34 -0700, H. Peter Anvin wrote:
>> On 04/24/2012 09:10 AM, Peter Zijlstra wrote:
>>
>> Are you sure that gcc won't simply generate this code already if given
>> "unsigned __int128"?
> 
> It might, but I've been told some GCC versions had issues, also lots of
> archs fall back to libgcc functions.
> 

Yes, but this is specific to x86-64.  If gcc can generate the code it
can also schedule the code, which it can't for assembly...

	-hpa


