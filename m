Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab2GOPNj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 11:13:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43366 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2GOPNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 11:13:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAGfj0KvyV+YgXeLYqDggA06=ZxNKtF3rBOGvOPnbsrchRMH0bg@mail.gmail.com>
References: <CAGfj0KvyV+YgXeLYqDggA06=ZxNKtF3rBOGvOPnbsrchRMH0bg@mail.gmail.com>
Date: Sun, 15 Jul 2012 23:13:31 +0800
Message-ID: <CAM_iQpUAif2V0uATnB729shnTJ_x_V0BE=HOCTZcyQK7cec6qQ@mail.gmail.com>
Subject: Re: Unable to resolve the error
From: Cong Wang <xiyou.wangcong@gmail.com>
To: rakesh singh <rks.linux.88@gmail.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, swarren@nvidia.com,
        broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2012 at 5:22 PM, rakesh singh <rks.linux.88@gmail.com> wrote:
> make -C /usr/src/linux-headers-2.6.38-8-generic/
> SUBDIRS=/home/rakesh/Desktop/m modules
> make[1]: Entering directory `/usr/src/linux-headers-2.6.38-8-generic'
>   CC [M]  /home/rakesh/Desktop/m/hello.o
> /home/rakesh/Desktop/m/hello.c:1:70: fatal error:
> usr/src/linux-headers-2.6.38-8-generic/include/linux/init.h: No such
> file or directory

You need to install some kernel package provided by your distro,
on Fedora it is kernel-devel.
