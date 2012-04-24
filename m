Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab2DXWDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:03:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38026 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757015Ab2DXWDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:03:31 -0400
Message-ID: <4F972321.4010009@zytor.com>
Date: Tue, 24 Apr 2012 15:03:13 -0700
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
References: <20120424161039.293018424@chello.nl>    <20120424162224.588822231@chello.nl> <4F96D604.5050709@zytor.com>   <1335285395.28150.204.camel@twins> <4F96E01E.6040109@zytor.com>  <1335287973.28150.213.camel@twins> <4F96E0EB.7030904@zytor.com> <1335304843.28150.246.camel@twins>
In-Reply-To: <1335304843.28150.246.camel@twins>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 03:00 PM, Peter Zijlstra wrote:
> 
> I haven't been able to make add_u128 generate sane code using __int128,
> the conversion between my struct and the __int128 layout makes a horrid
> mess.
> 

Use a union, or define your type simply as __int128 if you're on a
suitable platform?

	-hpa

