Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab1KKVaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 16:30:06 -0500
Received: from lo.gmane.org ([80.91.229.12]:49424 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab1KKVaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 16:30:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Subject: Re: [PATCH] sched: Add a comment to effective_load() since its a
 pain
Date: Fri, 11 Nov 2011 13:27:11 -0800
Message-ID: <4EBD932F.5050000@google.com>
References: <1318518057.27731.2.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
X-Gmane-NNTP-Posting-Host: 216-239-45-4.google.com
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
In-Reply-To: <1318518057.27731.2.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 08:00 AM, Peter Zijlstra wrote:
> Subject: sched: Add a comment to effective_load() since its a pain
> From: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Date: Thu Oct 13 16:52:28 CEST 2011
>
> Every time I have to stare at this function I need to completely
> reverse engineer its workings, about time I write a comment explaining
> the thing.

I'm glad I'm not the only one!

>
> Collected bits and pieces from previous changelogs, mostly:
>    4be9daaa1b33701f011f4117f22dc1e45a3e6e34
>    83378269a5fad98f562ebc0f09c349575e6cbfe1
>
> Signed-off-by: Peter Zijlstra<a.p.zijlstra@chello.nl>

Signed-off-by: Paul Turner <pjt@google.com>


