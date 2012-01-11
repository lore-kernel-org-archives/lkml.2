Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab2AKMOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 07:14:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62234 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab2AKMOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 07:14:53 -0500
MIME-Version: 1.0
In-Reply-To: <20120110165743.GE4118@suse.de>
References: <CAJd=RBDAoNt=TZWhNeLs0MaCJ_ormEp=ya55-PA+B0BAxfGbbQ@mail.gmail.com>
	<20120110094026.GB4118@suse.de>
	<CAJd=RBBNK6P=Kq09G88UDEsiU8KUPiko5WTfLgQqKzry8tVH5A@mail.gmail.com>
	<20120110165743.GE4118@suse.de>
Date: Wed, 11 Jan 2012 20:14:52 +0800
Message-ID: <CAJd=RBAMn0Zi49iukLfV1S3je08OCqFv3nu=CZG1WTNyom7nig@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: no change of reclaim mode if unevictable page encountered
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 12:57 AM, Mel Gorman <mgorman@suse.de> wrote:
>
> When I said it needed more justification, I meant that you need to show
> a workload or usecase that suffers as a result of reset_reclaim_mode
> being called here. I explained already that the reset errs on the
> side of caution by making reclaim work less.
>
> You need to describe what problem your workload is suffering from and
> why this patch fixes it.
>
Got and thanks for review /Hillf
