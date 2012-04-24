Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab2DXR1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:27:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35982 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725Ab2DXR1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:27:34 -0400
Message-ID: <4F96E27A.1010503@zytor.com>
Date: Tue, 24 Apr 2012 10:27:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [RFC][PATCH 0/3] gcc work-around and math128
References: <20120424161039.293018424@chello.nl> <4F96E154.2060100@zytor.com>
In-Reply-To: <4F96E154.2060100@zytor.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 10:22 AM, H. Peter Anvin wrote:
> On 04/24/2012 09:10 AM, Peter Zijlstra wrote:
>>
>> So far its just mult, add and cmp for u128, no divisions quite yet. I realize
>> that on 32bit archs mult_u128 will result in like 8 multiplication
>> instructions that's still nowhere near the most expensive thing ever.
>>
> 
> Please add shifts, at the very least.
> 

Oh, and a constant constructor.

	-hpa

