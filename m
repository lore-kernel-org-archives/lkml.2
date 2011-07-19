Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1GSGpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 02:45:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49299 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab1GSGpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 02:45:20 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MWQACM5FuvUkAP5sReY1Fzx9ea1wRRUvFNmaOc=Vp6FcQ@mail.gmail.com>
References: <CAM_iQpX_0U26_1yX+VJwhkkA7Un6Mj53AqPpRK36ONM32u4BKA@mail.gmail.com>
	<CACqU3MWQACM5FuvUkAP5sReY1Fzx9ea1wRRUvFNmaOc=Vp6FcQ@mail.gmail.com>
Date: Tue, 19 Jul 2011 14:45:19 +0800
Message-ID: <CAM_iQpU4OXFkPc0sZfwEf27mDyd9aNOptH6BBVkiSd8Y-cVTeA@mail.gmail.com>
Subject: Re: [Patch] fix a headers_check warning in include/linux/kernel.h
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 12:51 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Sun, Jul 17, 2011 at 3:46 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> This fixes the warning:
>>
>> linux-2.6/usr/include/linux/kernel.h:65: userspace cannot reference
>> function or variable defined in the kernel
>>
>> As Michal noted, BUILD_BUG_ON stuffs should be moved
>> under #ifdef __KERNEL__.
>>
>> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>>
> Why not all the other macros below the BUILD_BUG_ON stuff ? E.g. do we
> want to export __FUNCTION__ ? NUMA_BUILD ? COMPACTION_BUILD ?
> REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD ?
>

Right, certainly we should move them too.

I saw Andrew already merged a delta patch. Thanks to both of you!
