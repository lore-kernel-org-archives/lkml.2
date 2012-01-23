Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab2AWQVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:21:05 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57511 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab2AWQVD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:21:03 -0500
MIME-Version: 1.0
In-Reply-To: <1327323393.2446.9.camel@twins>
References: <1326991042.6107.4.camel@localhost.localdomain>
	<1327323393.2446.9.camel@twins>
Date: Mon, 23 Jan 2012 22:21:02 +0600
Message-ID: <CADZ9YHgKBaf-Ln+D9SxzR2RoZ2BiKWqeTzwrX39ns9MJoOgPhA@mail.gmail.com>
Subject: Re: [PATCH] sched/stats: Keep legacy array expiration field to zero.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 6:56 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-01-19 at 22:37 +0600, Rakib Mullick wrote:
>> A patch (https://lkml.org/lkml/2012/1/12/224) was sent previously to
>> update scheduler stat documentation to address array expiration
>> field's use. Then Ingo suggest that, we should also make sure that
>> we're exporting a value of zero. So, this patch does those
>> accordingly.
>
>
> This is not a valid changelog

Ok, I'll elaborate the changelog. (Actually, I had my finger crossed :) )
>
> This leaves sched_switch completely unused:
>
> # git grep -e "\<sched_switch\>"  kernel/sched/
> kernel/sched/debug.c:   P(sched_switch);
> kernel/sched/sched.h:   unsigned int sched_switch;
> kernel/sched/stats.c:               rq->sched_switch, rq->sched_count, rq->sched_goidle,
>
> Best kill that too
>
I asked on previous posting about removing rq->sched_switch. But
didn't get any specific answer. Anyway, will do it.

Thanks,
Rakib
