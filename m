Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab2CRTrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 15:47:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41210 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab2CRTrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 15:47:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120313005855.GA24639@redhat.com>
References: <20120313005855.GA24639@redhat.com>
Date: Sun, 18 Mar 2012 20:47:19 +0100
Message-ID: <CAFLxGvxXBp1+D3Az7onYYvvi9S=_pPLSFpHqOCurjYwTpxbB6w@mail.gmail.com>
Subject: Re: [3.3-rc7] sys_poll use after free (hibernate)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 1:58 AM, Dave Jones <davej@redhat.com> wrote:
> While trying to reproduce the i915 memory corruption problem with hibernate,
> I've hit the following use-after-free quite a few times, by running my
> syscall fuzzer and hibernating/resuming in a loop.
>

If you cannot reproduce the problem you can send me debug/test-patches.
I have two machines where I can reproduce the issue within an hour.

-- 
Thanks,
//richard
