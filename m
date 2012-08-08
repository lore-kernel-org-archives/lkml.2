Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab2HHHtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 03:49:46 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45836 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2HHHtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 03:49:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120808074622.GB3824@b20223-02.ap.freescale.net>
References: <20120808074622.GB3824@b20223-02.ap.freescale.net>
Date: Wed, 8 Aug 2012 09:49:44 +0200
Message-ID: <CAFLxGvwjbT43Q15Sr+d_jFD8yH46My9KHaE=KCH1i2uek0Zmig@mail.gmail.com>
Subject: Re: how to vm_munmap memory range for other processes?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: viro@zeniv.linux.org.uk, dirk.behme@de.bosch.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 9:46 AM, Richard Zhao <richard.zhao@freescale.com> wrote:
> Hi Al,
>
> I saw two commits from you in git tree:
> 17d1587 unexport do_munmap()
> bfce281 kill mm argument of vm_munmap()
>
> They remove the mm arguments, so it look like impossible to unmap
> memory of other processes except current.
>
> I have a kernel module that needs to unmap memory for certain pid. Do
> you have any idea how to do it?

AFAIK Al removed this because it's racy in many ways...

---
Thanks,
//richard
