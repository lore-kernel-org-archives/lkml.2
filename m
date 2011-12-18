Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab1LRJKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 04:10:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab1LRJKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 04:10:35 -0500
Message-ID: <4EEDADF1.3040305@redhat.com>
Date: Sun, 18 Dec 2011 11:10:09 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Pierre Habouzit <pierre.habouzit@intersec.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: allow preempt notifiers to self-unregister.
References: <1324052151-3714-1-git-send-email-pierre.habouzit@intersec.com>
In-Reply-To: <1324052151-3714-1-git-send-email-pierre.habouzit@intersec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 06:15 PM, Pierre Habouzit wrote:
>   As a background, this need is because I have some kind of module code
>   that uses this facility to evaluate how many of a group of threads are
>   concurrently running (to regulate a pool of threads).
>

That's what's cmwq is supposed to be doing (and that too should be using
preempt notifiers, IMO).


-- 
error compiling committee.c: too many arguments to function

