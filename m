Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab2IDUkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:40:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62199 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab2IDUkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:40:03 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: a3at.mail@gmail.com
In-Reply-To: <CAAW1UO-nXDDAB9fC6fDJ6+XVnidXOARdVhq=_XJgngmnMj7gPQ@mail.gmail.com>
References: <CAAW1UO-nXDDAB9fC6fDJ6+XVnidXOARdVhq=_XJgngmnMj7gPQ@mail.gmail.com>
Date: Wed, 5 Sep 2012 00:40:01 +0400
X-Google-Sender-Auth: FMNomNlyR3RCECiaQ4NSJBoIJTQ
Message-ID: <CAAW1UO8p72L9XtdQP6=y82AdyaRtTK5OjvjSM=LwN0+3Q4KJ7w@mail.gmail.com>
Subject: Re: high load average in linux-3.6
From: Azat Khuzhin <dohardgopro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can anybody say is this fixed or not?
Or maybe you need more information?

Thanks.

On Fri, Aug 17, 2012 at 1:10 AM, Azat Khuzhin <dohardgopro@gmail.com> wrote:
> Hi all.
>
> After updating to linux-v3.6-rc1-315-g3c31a6e I noticed that load avg
> is too high for "current" CPU usage & IO activity
>
> Just after starting, I see next things:
> 1) I'v kill all processes that I "can"
> iostat_min_tasks - http://pastebin.com/T59xKEy4
> ps_min_tasks - http://pastebin.com/b7zVy6up
> w_min_tasks - http://pastebin.com/UFFsncSn
>
> 2) After I started some processes/services (kde,nginx,mysql ...)
> iostat_with_graph - http://pastebin.com/bejGneGv
> ps_with_graph - http://pastebin.com/Nt9g0ynW
> w_with_graph - http://pastebin.com/pYuUbyVY
> ( graph - with DE )
>
> When I 3.3.0 I did not notice such situation.
>
> I'v trying to set kernel cmd line to "i915.i915_enable_rc6=1
> i915.i915_enable_fbc=1 i915.lvds_downclock=1 drm.vblankoffdelay=1"
> like here https://bugs.archlinux.org/task/29850
> But this doesn't helps.
>
> --
> Azat Khuzhin



-- 
Azat Khuzhin
