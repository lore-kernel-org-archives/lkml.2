Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2IQDfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 23:35:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57373 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2IQDfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 23:35:44 -0400
MIME-Version: 1.0
In-Reply-To: <CANEcBPQnsV26UkyGxms0vKM9wK1NxfKjN4Z0qGipQtV4UPZgGA@mail.gmail.com>
References: <CANEcBPSEamgOiGqNUSwB+hYCo1k2OTXDA=qsrw0Co8_F7treWw@mail.gmail.com>
	<CANEcBPQnsV26UkyGxms0vKM9wK1NxfKjN4Z0qGipQtV4UPZgGA@mail.gmail.com>
Date: Mon, 17 Sep 2012 11:35:43 +0800
Message-ID: <CAM_iQpUkcgHtOvyqBPE4==nHegW_3oC+38Ka5OrK5+9WK6G=eQ@mail.gmail.com>
Subject: Re: [PATCH] fix ZOMBIE state bug in PPPOE driver
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Xiaodong Xu <stid.smth@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 10:30 AM, Xiaodong Xu <stid.smth@gmail.com> wrote:
> Hi All,
>
> I found a bug in kernel PPPOE driver.
> When PPPOE is running over a virtual ethernet interface (e.g., a
> bonding interface) and the user tries to delete the interface in case
> the PPPOE state is ZOMBIE, the kernel will loop infinitely while
> unregistering net_device for the reference count is not reset to zero
> which should be done by dev_put().
>
> The following patch could fix this issue:

You missed your Signed-off-by, please read
Documentation/SubmittingPatches and check your patch with
scripts/checkpatch.pl before sending.
