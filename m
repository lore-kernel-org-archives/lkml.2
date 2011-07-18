Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab1GRQv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 12:51:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49548 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1GRQv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:51:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAM_iQpX_0U26_1yX+VJwhkkA7Un6Mj53AqPpRK36ONM32u4BKA@mail.gmail.com>
References: <CAM_iQpX_0U26_1yX+VJwhkkA7Un6Mj53AqPpRK36ONM32u4BKA@mail.gmail.com>
Date: Mon, 18 Jul 2011 12:51:26 -0400
Message-ID: <CACqU3MWQACM5FuvUkAP5sReY1Fzx9ea1wRRUvFNmaOc=Vp6FcQ@mail.gmail.com>
Subject: Re: [Patch] fix a headers_check warning in include/linux/kernel.h
From: Arnaud Lacombe <lacombar@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 17, 2011 at 3:46 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> This fixes the warning:
>
> linux-2.6/usr/include/linux/kernel.h:65: userspace cannot reference
> function or variable defined in the kernel
>
> As Michal noted, BUILD_BUG_ON stuffs should be moved
> under #ifdef __KERNEL__.
>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>
Why not all the other macros below the BUILD_BUG_ON stuff ? E.g. do we
want to export __FUNCTION__ ? NUMA_BUILD ? COMPACTION_BUILD ?
REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD ?

 - Arnaud
