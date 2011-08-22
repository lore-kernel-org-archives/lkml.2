Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1HVOfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:35:19 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:41244 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1HVOfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:35:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAK3+h2xAca9HVi_VBu4taSrG=BX_N=cbUqxFsfhn5xaX6gkbvA@mail.gmail.com>
References: <CAK3+h2xAca9HVi_VBu4taSrG=BX_N=cbUqxFsfhn5xaX6gkbvA@mail.gmail.com>
Date: Mon, 22 Aug 2011 22:35:15 +0800
Message-ID: <CAM_iQpXnDq2Y0wXZgC2yB4KZR_pBYj7Uz4K9ZpeP=5YFpMLfhw@mail.gmail.com>
Subject: Re: Is arch/x86_64 kernel relocatable by default from redhat
 enterprise 5 originated kernel?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Vincent Li <vincent.mc.li@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 6:10 AM, Vincent Li <vincent.mc.li@gmail.com> wrote:
> Hi,
>

Hi,

>
> so it looks  the 64bit kernel is not relocatable according to above
> error, then I went to the distro's kernel source directory and
> couldn't find "RELOCATABLE" config in arch/x86_64/Kconfig, there is
> "RELOCATABLE" config in arch/i386/Kconfig. so I am bit
> confused if arch/x86_64 kernel is relocatable by default or
> relocatable is not supported yet for the redhat 5 originated x86_64
> kernel.

I think x86_64 is relocatable by default, as on RHEL5 x86_64 we
only have one vmlinuz for both production kernel and kdump kernel.

I don't know the history, probably x86_64 supports relocatable from
the beginning, thus there is no such Kconfig on RHEL5.

>
> I also suspect that kexec-tools-1.102pre-126.el5.i386.rpm might be the
> culprit here since it is for i386, but I couldn't install
> kexec-tools-1.102pre-126.el5.x86_64.rpm  lack of 64 bit libc.so.6 on
> the custom distro
>

So, probably this is the cause of the problem.

Thanks.
