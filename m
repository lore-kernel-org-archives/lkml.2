Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab1JZU3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:29:03 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62410 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab1JZU3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:29:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAEwRVpN8o_end=NJzTHS5p=u1O8vQ+PenAzGoFMfx7Ore73-Rw@mail.gmail.com>
References: <CAAfyv36xXQpmDy4Lo2ut+-i2ussgBcmQ+hpQuSEupKxbLubo=g@mail.gmail.com>
	<CAEwRVpN8o_end=NJzTHS5p=u1O8vQ+PenAzGoFMfx7Ore73-Rw@mail.gmail.com>
Date: Wed, 26 Oct 2011 22:29:00 +0200
Message-ID: <CAAfyv37K2wsjiehY89sjcsZeU6Qci+i8thi+2pX1OO9=2dcLTA@mail.gmail.com>
Subject: Re: stable kernel releases
From: Belisko Marek <marek.belisko@gmail.com>
To: Teck Choon Giam <giamteckchoon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 12:13 AM, Teck Choon Giam
<giamteckchoon@gmail.com> wrote:
> On Tue, Oct 25, 2011 at 3:41 AM, Belisko Marek <marek.belisko@gmail.com> wrote:
>> Is there another git  location for stable kernels?
>> Like 2.6.39, 2.6.38? Kernel org still missing that part.
>
> Isn't it all in
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
> ?
Thanks that's the link I need ;)
>
> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
> $ cd linux-stable
> $ git branch -a
>  remotes/origin/HEAD -> origin/master
>  remotes/origin/linux-2.6.11.y
>  remotes/origin/linux-2.6.12.y
>  remotes/origin/linux-2.6.13.y
>  remotes/origin/linux-2.6.14.y
>  remotes/origin/linux-2.6.15.y
>  remotes/origin/linux-2.6.16.y
>  remotes/origin/linux-2.6.17.y
>  remotes/origin/linux-2.6.18.y
>  remotes/origin/linux-2.6.19.y
>  remotes/origin/linux-2.6.20.y
>  remotes/origin/linux-2.6.21.y
>  remotes/origin/linux-2.6.22.y
>  remotes/origin/linux-2.6.23.y
>  remotes/origin/linux-2.6.24.y
>  remotes/origin/linux-2.6.25.y
>  remotes/origin/linux-2.6.26.y
>  remotes/origin/linux-2.6.27.y
>  remotes/origin/linux-2.6.28.y
>  remotes/origin/linux-2.6.29.y
>  remotes/origin/linux-2.6.30.y
>  remotes/origin/linux-2.6.31.y
>  remotes/origin/linux-2.6.32.y
>  remotes/origin/linux-2.6.33.y
>  remotes/origin/linux-2.6.34.y
>  remotes/origin/linux-2.6.35.y
>  remotes/origin/linux-2.6.36.y
>  remotes/origin/linux-2.6.37.y
>  remotes/origin/linux-2.6.38.y
>  remotes/origin/linux-2.6.39.y
>  remotes/origin/linux-3.0.y
>  remotes/origin/linux-3.1.y
>  remotes/origin/master
>
> Like if you want 2.6.32 for example:
>
> $ git checkout -b linux-2.6.32.y --track remotes/origin/linux-2.6.32.y
> $ git log -1
> commit b0b3e41f6fe88a15bd27f73f6fabef48e0fea2f0
> Author: Greg Kroah-Hartman <gregkh@suse.de>
> Date:   Mon Aug 29 14:31:54 2011 -0700
>
>    Linux 2.6.32.46
>
> If you want tags just:
>
> $ git fetch --tags -v
> SNAP
>  = [up to date]      v2.6.38    -> v2.6.38
>  = [up to date]      v2.6.38-rc1 -> v2.6.38-rc1
>  = [up to date]      v2.6.38-rc2 -> v2.6.38-rc2
>  = [up to date]      v2.6.38-rc3 -> v2.6.38-rc3
>  = [up to date]      v2.6.38-rc4 -> v2.6.38-rc4
>  = [up to date]      v2.6.38-rc5 -> v2.6.38-rc5
>  = [up to date]      v2.6.38-rc6 -> v2.6.38-rc6
>  = [up to date]      v2.6.38-rc7 -> v2.6.38-rc7
>  = [up to date]      v2.6.38-rc8 -> v2.6.38-rc8
>  = [up to date]      v2.6.38.1  -> v2.6.38.1
>  = [up to date]      v2.6.38.2  -> v2.6.38.2
>  = [up to date]      v2.6.38.3  -> v2.6.38.3
>  = [up to date]      v2.6.38.4  -> v2.6.38.4
>  = [up to date]      v2.6.38.5  -> v2.6.38.5
>  = [up to date]      v2.6.38.6  -> v2.6.38.6
>  = [up to date]      v2.6.38.7  -> v2.6.38.7
>  = [up to date]      v2.6.38.8  -> v2.6.38.8
>  = [up to date]      v2.6.39    -> v2.6.39
>  = [up to date]      v2.6.39-rc1 -> v2.6.39-rc1
>  = [up to date]      v2.6.39-rc2 -> v2.6.39-rc2
>  = [up to date]      v2.6.39-rc3 -> v2.6.39-rc3
>  = [up to date]      v2.6.39-rc4 -> v2.6.39-rc4
>  = [up to date]      v2.6.39-rc5 -> v2.6.39-rc5
>  = [up to date]      v2.6.39-rc6 -> v2.6.39-rc6
>  = [up to date]      v2.6.39-rc7 -> v2.6.39-rc7
>  = [up to date]      v2.6.39.1  -> v2.6.39.1
>  = [up to date]      v2.6.39.2  -> v2.6.39.2
>  = [up to date]      v2.6.39.3  -> v2.6.39.3
>  = [up to date]      v2.6.39.4  -> v2.6.39.4
> SNAP
>
> Hope this is what you are looking for?
>
> Thanks.
>
> Kindest regards,
> Giam Teck Choon
>

regards,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
