Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab0HHFyL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 01:54:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58378 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab0HHFyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 01:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=EroXNuBoenc5kb/RMzQq+Mk9t7FcYiRvn+ivR6ssv2yo9bWzeB7MFraQFowaqYIo+F
         0BCZtiEqVdpV0q1AunxLXD3GSFHA/ktyLwPXNXDcNiqkQim9g11Ed/9WibU6Eyys0rK1
         QFCIMc/djyfFwKJGzmguhMKw+i0c5qs6mlP0E=
MIME-Version: 1.0
In-Reply-To: <4C5D7C4C.1020206@kernel.org>
References: <1281194812-18052-1-git-send-email-namhyung@gmail.com>
	<4C5D7C4C.1020206@kernel.org>
Date: Sun, 8 Aug 2010 11:24:05 +0530
X-Google-Sender-Auth: -l0-H1PudSViSICcFF_ikdN4pfI
Message-ID: <AANLkTikvBwMG1sjYK3cizi+x0EXosnP-cRL7bwCgHEzN@mail.gmail.com>
Subject: Re: [PATCH] cgroup: add missing __percpu markup in mm/memcontrol.c
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 7, 2010 at 9:01 PM, Tejun Heo <tj@kernel.org> wrote:
> From: Namhyung Kim <namhyung@gmail.com>
>
> mem_cgroup->stat is a percpu pointer but was missing __percpu markup.
> Add it.
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> ---
> Namhyung, can you please look up the maintainers in MAINTAINERS and/or
> using scripts/get_maintainer.pl and submit __percpu markup patches to
> the respective maintainers w/ me cc'd?
>

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Balbir
