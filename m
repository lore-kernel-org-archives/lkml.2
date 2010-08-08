Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab0HHCvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 22:51:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46223 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0HHCvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 22:51:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=odUYQLb4f2ToDplz0kYdC9+t35U6JbOzb7ZaWidsZj4yRvSRm6vfT3Y60OxtGx2ARS
         1qzKo4FNrxrDoPo0dtOgmZkt7FFJg5/u6c9DtY+Jw0mYVvi/2Jqu5k+I7MrZ1E/tz/7N
         el5TT+kxWf5/egx1azk9lISuNwng8a5rZBrMI=
MIME-Version: 1.0
In-Reply-To: <4C5D7C4C.1020206@kernel.org>
References: <1281194812-18052-1-git-send-email-namhyung@gmail.com>
	<4C5D7C4C.1020206@kernel.org>
Date: Sun, 8 Aug 2010 11:51:45 +0900
Message-ID: <AANLkTim5bS_nwa_10i6i9u7At=9L+gpEPSyzqXPVP8mD@mail.gmail.com>
Subject: Re: [PATCH] cgroup: add missing __percpu markup in mm/memcontrol.c
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/8 Tejun Heo <tj@kernel.org>:
> From: Namhyung Kim <namhyung@gmail.com>
>
> mem_cgroup->stat is a percpu pointer but was missing __percpu markup.
> Add it.
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Acked-by: Tejun Heo <tj@kernel.org>

Thank you.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
