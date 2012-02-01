Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab2BADSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 22:18:35 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34181 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab2BADSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 22:18:34 -0500
MIME-Version: 1.0
In-Reply-To: <4F286529.1060407@gmail.com>
References: <4F286529.1060407@gmail.com>
Date: Wed, 1 Feb 2012 11:18:34 +0800
X-Google-Sender-Auth: 53wULCZlYJqlsOSqGxYj2wuPqLs
Message-ID: <CANejiEUVeqjgEHumtEaCTpLgdQ54DWa3HJF-3qj+7t8F2bTXeg@mail.gmail.com>
Subject: Re: cfq bug still not fixed on x86
From: Shaohua Li <shaohua.li@intel.com>
To: walt <w41ter@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

can you try the debug patch from Tejun:

http://marc.info/?l=linux-kernel&m=132683711206544&w=2

2012/2/1 walt <w41ter@gmail.com>:
> Hi guys.  Linus recently commited this bugfix from Jens:
>
> commit 54b466e44b1c7809144bbd8cd6be3f85877ca46f
> Author: Jens Axboe
> Date:   Tue Jan 17 21:26:11 2012 +0100
>
>    cfq-iosched: fix use-after-free of cfqq
>
> That fixed the problem on my amd64x2 machine, but my old UP x86 amd
> machine is still producing the same backtrace when udevd segfaults
> during bootup.
>
> I'm wondering if the patch neglects some 32-bit or non-SMP code?
>
> Thanks for all your hard work on open-source :)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
