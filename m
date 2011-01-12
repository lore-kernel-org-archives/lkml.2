Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab1ALJRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 04:17:33 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63153 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1ALJRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 04:17:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=J+lhFwiQtwmPxIAZPi9gJn/RzBK3EMOU27TKKwkNs2M8zrg/jzs5AamdkUarcuUtaF
         d9ktOejd0kZWg7khepsXYnMMUdGODwjrE/dXAulnam6L09xBXUGilzuI81cEGcF1QMYl
         GHA1qAtDtU2l8TTHc/GsWOEQsAdgAOoiCmd2U=
MIME-Version: 1.0
In-Reply-To: <20110112074930.GF2723@in.ibm.com>
References: <20110111101040.GD4772@in.ibm.com>
	<20110111101153.GE4772@in.ibm.com>
	<20110111124658.GA4507@zhy>
	<20110111134244.GJ4772@in.ibm.com>
	<20110111140005.GA6069@zhy>
	<20110112074930.GF2723@in.ibm.com>
Date: Wed, 12 Jan 2011 17:17:28 +0800
Message-ID: <AANLkTikCVPY=JFWyyQDv+4E2n3AWvQCFQu26m1CyUhDn@mail.gmail.com>
Subject: Re: [PATCH -tip 1/2] [PATCH -tip 1/2] sched: Reinstate group names in /proc/sched_debug.
From: Yong Zhang <yong.zhang0@gmail.com>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 3:49 PM, Bharata B Rao
<bharata@linux.vnet.ibm.com> wrote:
>> BTW, I guess we can also remove rcu_read_lock/unlock() in print_rt_stats()
>> and print_cfs_stats() with sched_debug_lock hold.
>
> We could, but I guess its not a recommended practice anymore to depend on
> spinlocks to protect rcu readside.

OK. Then let's keep it.

Thanks,
Yong

-- 
Only stand for myself
