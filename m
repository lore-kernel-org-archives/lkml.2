Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2KSGHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 01:07:47 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:61552 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab2KSGHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 01:07:46 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <1353129067.19744.1@driftwood>
References: <50A5E4D6.60301@gmail.com> <1353129067.19744.1@driftwood>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 19 Nov 2012 07:07:25 +0100
Message-ID: <CAKgNAkjCKpf-Nk6anL4tvETTyuuAZun=5SP6ssnsavDgJF563w@mail.gmail.com>
Subject: Re: [PATCH] Correct description of SwapFree in Documentation/filesystems/proc.txt
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        lkml <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Jim Paris <jim@jtan.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob,

On Sat, Nov 17, 2012 at 6:11 AM, Rob Landley <rob@landley.net> wrote:
> On 11/16/2012 01:01:42 AM, Michael Kerrisk wrote:
>>
>> After migrating most of the information in
>> Documentation/filesystems/proc.txt to the proc(5) man page,
>> Jim Paris pointed out to me that the description of SwapFree
>> in the man page seemed wrong. I think Jim is right,
>> but am given pause by fact that that text has been in
>> Documentation/filesystems/proc.txt since at least 2.6.0.
>> Anyway, I believe that the patch below fixes things.
>>
>> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
>
>
> Acked-by: Rob Landley <rob@landley.net>
>
> Want me to forward it on? (Lots of documentation stuff gets grabbed by
> whoever maintains what it's documenting, this looks like it might fall
> through the cracks...)

That would be great.

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
