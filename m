Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1GFR5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:57:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42213 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab1GFR5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:57:51 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
References: <cover.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 6 Jul 2011 11:57:21 -0600
Message-ID: <CAJfuBxyfA=Hjr8HEp47mKyr9fSdRGhppKr_-755vHQqn_RB=8Q@mail.gmail.com>
Subject: Re: [PATCH 00/10] dynamic_debug: various fixes
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, joe@perches.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        aloisio.almeida@openbossa.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 6, 2011 at 11:24 AM, Jason Baron <jbaron@redhat.com> wrote:
> Hi,
>
> Various dynamic debug fixes and cleanups, and a patch to add myself as
> maintainer. Hopefully, nobody will object too loudly :)
>

do you have this in a git-tree somewhere I can pull ?

> Thanks,
>
> -Jason
>
>
> Joe Perches (4):
>  dynamic_debug: Add __dynamic_dev_dbg
>  dynamic_debug: Consolidate prefix output to single routine
>  dynamic_debug: Remove uses of KERN_CONT in dynamic_emit_prefix
>  dynamic_debug: Convert printks to pr_<level>
>
> Jason Baron (6):
>  dynamic_debug: remove unused control variables
>  dynamic_debug: add myslef as maintainer
>  dynamic_debug: make netdev_dbg() call __netdev_printk()
>  dynamic_debug: make netif_dbg() call __netdev_printk()
>  dynamic_debug: consolidate repetitive struct _ddebug descriptor
>    definitions
>  dynamic_debug: remove num_enabled accounting
>
>  MAINTAINERS                   |    6 ++
>  drivers/base/core.c           |    5 +-
>  include/linux/device.h        |    5 +
>  include/linux/dynamic_debug.h |   58 ++++++++++-----
>  include/linux/netdevice.h     |   12 ++--
>  lib/dynamic_debug.c           |  165 ++++++++++++++++++++++++++++-------------
>  net/core/dev.c                |    3 +-
>  7 files changed, 172 insertions(+), 82 deletions(-)
>
> --
> 1.7.5.4
>
>
