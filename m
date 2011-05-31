Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab1EaVRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 17:17:04 -0400
Received: from outmail003.snc4.facebook.com ([66.220.144.135]:55601 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932497Ab1EaVRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 17:17:02 -0400
Message-ID: <4DE55AE9.90505@fb.com>
Date: Tue, 31 May 2011 14:17:29 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 2/2] atomic: move atomic_add_unless to generic code
References: <1306869046-20172-1-git-send-email-asharma@fb.com> <1306869046-20172-2-git-send-email-asharma@fb.com> <BANLkTi=Tg=t5LrnvR2Sn08K0Ktm8ZKNCCA@mail.gmail.com>
In-Reply-To: <BANLkTi=Tg=t5LrnvR2Sn08K0Ktm8ZKNCCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/11 1:21 PM, Mike Frysinger wrote:
> On Tue, May 31, 2011 at 15:10, Arun Sharma wrote:
>> This is in preparation for more generic atomic
>> primitives based on __atomic_add_unless.
>
> i think you might have to have those primitives in place before this
> patch makes sense.  the only thing this does is hoist a single
> comparison out of arch atomic.h's and into linux/atomic.h.  this
> savings alone looks simply like over engineering to me.

Some of the context is buried in the lkml-reference. The main motivation 
for the patch is commit 686a7e3.

The idea is to move atomic_add_unless_return() into linux/atomic.h

  -Arun

