Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab1FFVGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:06:08 -0400
Received: from outmail007.snc4.facebook.com ([66.220.144.139]:36213 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750919Ab1FFVGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:06:07 -0400
Message-ID: <4DED4160.4010403@fb.com>
Date: Mon, 06 Jun 2011 14:06:40 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 1/3] atomic: use <linux/atomic.h>
References: <1307381251-15729-1-git-send-email-asharma@fb.com> <1307393746.2642.26.camel@edumazet-laptop>
In-Reply-To: <1307393746.2642.26.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/11 1:55 PM, Eric Dumazet wrote:

> OK, you moved atomic_inc_not_zero() into include/linux/atomic.h without
> telling so in Changelog.
>
> Reviewed-by: Eric Dumazet<eric.dumazet@gmail.com>
>

Thanks for the review. I amended the commit message as follows:

commit 283188caee98f9c106ee943374589571939ca75a
Author: Arun Sharma <asharma@fb.com>
Date:   Tue May 31 11:11:10 2011 -0700

     atomic: use <linux/atomic.h>

     This allows us to move duplicated code in <asm/atomic.h>
     (atomic_inc_not_zero() for now) to <linux/atomic.h>

     More cleanup patches to follow.

  -Arun
