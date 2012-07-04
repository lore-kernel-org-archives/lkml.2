Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab2GDGFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:05:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50578 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2GDGFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:05:13 -0400
MIME-Version: 1.0
In-Reply-To: <1341342768-22221-1-git-send-email-geert@linux-m68k.org>
References: <1341342768-22221-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 4 Jul 2012 14:05:12 +0800
Message-ID: <CAM_iQpXtugw1zwVqgO7sMZdMde-KivAg7p1C6GtrdiwhLfpyNA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.5-rc5
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 3:12 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Below is the list of build error/warning regressions/improvements in
> v3.5-rc5[1] compared to v3.4[2].
>
...
>   + fs/jbd2/commit.c: warning: '__kunmap_atomic_deprecated' is deprecated (declared at /scratch/kisskb/src/include/linux/highmem.h:135) [-Wdeprecated-declarations]:  => 357:1, 357:176
>   + fs/jbd2/commit.c: warning: '__kunmap_atomic_deprecated' is deprecated (declared at /scratch/kisskb/src/include/linux/highmem.h:137):  => 357
>   + fs/jbd2/commit.c: warning: 'kmap_atomic_deprecated' is deprecated (declared at /scratch/kisskb/src/include/linux/highmem.h:125) [-Wdeprecated-declarations]:  => 352:2
>   + fs/jbd2/commit.c: warning: 'kmap_atomic_deprecated' is deprecated (declared at /scratch/kisskb/src/include/linux/highmem.h:127):  => 352

This should be fixed by my patch:
https://lkml.org/lkml/2012/6/23/70

Thanks!
