Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab1FBRWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 13:22:43 -0400
Received: from outmail012.snc4.facebook.com ([66.220.144.144]:56574 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753057Ab1FBRWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 13:22:42 -0400
Message-ID: <4DE7C6FF.70108@fb.com>
Date: Thu, 02 Jun 2011 10:23:11 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 2/2] atomic: move atomic_add_unless to generic code
References: <1306869046-20172-1-git-send-email-asharma@fb.com> <1306869046-20172-2-git-send-email-asharma@fb.com> <BANLkTi=Tg=t5LrnvR2Sn08K0Ktm8ZKNCCA@mail.gmail.com> <4DE55AE9.90505@fb.com> <BANLkTi=nKqwFKt8boNHQ=imgEz0fdyGCqw@mail.gmail.com>
In-Reply-To: <BANLkTi=nKqwFKt8boNHQ=imgEz0fdyGCqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/11 7:53 AM, Mike Frysinger wrote:

>> The idea is to move atomic_add_unless_return() into linux/atomic.h
>
> my point is that that patchset doesnt seem to exist yet, and it'd
> probably make sense to have it ready and part of this series before
> attempting to push this.

I posted the patch a couple of days ago:

1306889876-5327-1-git-send-email-asharma@fb.com
http://thread.gmane.org/gmane.linux.kernel/1148420

  -Arun

