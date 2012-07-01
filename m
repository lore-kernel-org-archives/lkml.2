Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab2GAQNh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 12:13:37 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60676 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2GAQNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 12:13:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120701145853.GA22259@fancy-poultry.org>
References: <CAJd=RBBSEVOUL-J=gGWO4FpbtC30_A8eb6HyKK48ZdjmNn_y-Q@mail.gmail.com>
	<20120701145853.GA22259@fancy-poultry.org>
Date: Sun, 1 Jul 2012 23:13:35 +0700
Message-ID: <CA+i8gKKnz1i-ojwUP5AetBLsGVLyRXP3FNUXA1UkMm430ZYXFA@mail.gmail.com>
Subject: Re: [RFC patch] BFS: 421-1
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: linux-kernel@vger.kernel.org, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 1, 2012 at 9:58 PM, Heinz Diehl <htd@fancy-poultry.org> wrote:
> On 01.07.2012, Hillf Danton wrote:
>
>> With 15 patches collected, the 421-1 is ready with iso untouched.
>> Note diff is based not on 420 but on 421.
> [....]
>
> There is no v.421 on ck.kolivas.org, and it seems it never has
> been, at least there is a patch which updates v.420 directly to v.422
> which indicates that there isn't any v.421. So what version is your
> patchset actually based on?

Con skipped 421 because Hillf did release a 421 BFS, he wanted to
avoid confusion. There are two patches in this thread, the first one
is based on Hillf's 421 (you can find the patch on lkml) and a second
one based on Con's 420 BFS. Hope it's a bit more clear now.

@Hillf, 421-1 builds and boots fine. Too early for me to give any
feedback on improvements and/or regressions this patch brings.
