Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965173Ab2CPUea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:34:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58182 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867Ab2CPUe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:34:28 -0400
MIME-Version: 1.0
In-Reply-To: <m1zkbjauqj.fsf@fess.ebiederm.org>
References: <1331690897-26496-1-git-send-email-jesse@nicira.com> <m1zkbjauqj.fsf@fess.ebiederm.org>
From: Jesse Gross <jesse@nicira.com>
Date: Fri, 16 Mar 2012 13:34:07 -0700
Message-ID: <CAEP_g=-OD5m+VGxmk+r1C=3T1qsFm4vyFhS-zE_34CoPi4zBEw@mail.gmail.com>
Subject: Re: [PATCH] proc-ns: Use d_set_d_op() API to set dentry ops in proc_ns_instantiate().
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Pravin B Shelar <pshelar@nicira.com>,
        Justin Pettit <jpettit@nicira.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:43 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Jesse Gross <jesse@nicira.com> writes:
>
>> From: Pravin B Shelar <pshelar@nicira.com>
>>
>> Use d_set_d_op() so that DCACHE_OP_* flags are set correctly which fixes ns
>> cleanup path i.e. `ip netns delete `.
>>
>> This issue exists back to 3.0.
>
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Jesse thanks for picking this up and giving this a push.  This is most
> definitely the right fix and it most definitely solves issues.   Somehow
> this fix got lost when I sent it to Linus the first time.

Thanks Eric, I didn't realize that you had picked it up the first time
around, which is why I figured that I'd try Andrew.  I haven't heard
anything from him so do you want to take it? (I'm not quite sure who
owns this piece of code, sorry if it's already been handled.)
