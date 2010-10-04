Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab0JDC1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 22:27:33 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:40616 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab0JDC1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 22:27:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bZCFjaUKISmBU3FF8noToBEo5S3en/y/GC27Uad6yJ3azxn8EDITy9sN8fvXDv6/NL
         nbN2rk+RhLpFgyEJ8dUC1MI12S3LKCYMC/mbt1YDn12aETBO8RUl9ayXZg2ADrqg0iNR
         lq5/O6eLS/h3kzx5D4YqLHntjI1GuL8XqUI+Y=
Date: Mon, 4 Oct 2010 10:32:07 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Dragoslav Zaric <zaricdragoslav@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Makefile for kernel modules
Message-ID: <20101004023207.GB5189@cr0.nay.redhat.com>
References: <AANLkTikKjP-VLkygYbyg8THiCuM=vBfGaqq49+cuBj6u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikKjP-VLkygYbyg8THiCuM=vBfGaqq49+cuBj6u@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 02, 2010 at 09:20:16PM +0400, Dragoslav Zaric wrote:
...
>
>But if I have two kernel modules source files, for example, start.c
>and stop.c, my Makefile will look like this:
>---------------------------------------------------------------------------
>obj-m += startstop.o
>startstop-objs := start.o stop.o

startstop-objs should be startstop-y

>
>all:
>	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
>clean:
>	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
>---------------------------------------------------------------------------
>But this does not work on my machine, it runs without errors but does
>not produce startstop.ko file.
>Also, when I run make on my machine, first line that appears is:
>---------------------------------------------------------------------------
>make -C /lib/modules/2.6.33.7-rt29/build
>M=/home/maiev/work/modules/parts modules
>---------------------------------------------------------------------------
>
>So, does anybody know what are lines for manual kernel module
>compilation using probably gcc,
>without 'obj-m +=' or at least how Makefile should look for multiple
>kernel module source files ???
>

Please read Documentation/kbuild/modules.txt.

Thanks.
