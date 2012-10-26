Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203Ab2JZOIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:08:19 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42965 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043Ab2JZOIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:08:16 -0400
MIME-Version: 1.0
In-Reply-To: <1350602308-2120-1-git-send-email-js1304@gmail.com>
References: <1350602308-2120-1-git-send-email-js1304@gmail.com>
Date: Fri, 26 Oct 2012 23:08:15 +0900
Message-ID: <CAAmzW4MTfGyjLHm5o4eHOonxgvz9+Nk8E9rXRsh6_gvcXe2vyw@mail.gmail.com>
Subject: Re: [PATCH 0/2] clean-up initialization of deferrable timer
From: JoonSoo Kim <js1304@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/19 Joonsoo Kim <js1304@gmail.com>:
> This patchset introduces setup_timer_deferrable() macro.
> Using it makes code simple and understandable.
>
> This patchset doesn't make any functional difference.
> It is just for clean-up.
>
> It is based on v3.7-rc1
>
> Joonsoo Kim (2):
>   timer: add setup_timer_deferrable() macro
>   timer: use new setup_timer_deferrable() macro
>
>  drivers/acpi/apei/ghes.c                     |    5 ++---
>  drivers/ata/libata-core.c                    |    5 ++---
>  drivers/net/ethernet/nvidia/forcedeth.c      |   13 ++++---------
>  drivers/net/ethernet/qlogic/qlge/qlge_main.c |    4 +---
>  drivers/net/vxlan.c                          |    5 ++---
>  include/linux/timer.h                        |    2 ++
>  kernel/workqueue.c                           |    6 ++----
>  net/mac80211/agg-rx.c                        |   12 ++++++------
>  net/mac80211/agg-tx.c                        |   12 ++++++------
>  net/sched/cls_flow.c                         |    5 ++---
>  net/sched/sch_sfq.c                          |    5 ++---
>  11 files changed, 31 insertions(+), 43 deletions(-)
>
> --
> 1.7.9.5

Hello, Thomas.
Will you pick this for your tree?
Or is there anything wrong with it?

Thanks.
