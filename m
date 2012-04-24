Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab2DXQej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:34:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35547 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab2DXQei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:34:38 -0400
Message-ID: <4F96D604.5050709@zytor.com>
Date: Tue, 24 Apr 2012 09:34:12 -0700
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
References: <20120424161039.293018424@chello.nl> <20120424162224.588822231@chello.nl>
In-Reply-To: <20120424162224.588822231@chello.nl>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 09:10 AM, Peter Zijlstra wrote:

Are you sure that gcc won't simply generate this code already if given
"unsigned __int128"?

	-hpa
