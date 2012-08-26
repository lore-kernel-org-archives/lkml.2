Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab2HZGkA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 02:40:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57940 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab2HZGj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 02:39:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120825173725.GD3363@breakpoint.cc>
References: <1345909883-29977-1-git-send-email-amwang@redhat.com>
	<20120825173725.GD3363@breakpoint.cc>
Date: Sun, 26 Aug 2012 14:39:58 +0800
Message-ID: <CAM_iQpWjEKhY_gv0YLeJR6ymdZY5JHte_EQ8d0f0zuBHURG0kg@mail.gmail.com>
Subject: Re: [Patch] block: remove the deprecated ub driver
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 1:37 AM, Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
> On Sat, Aug 25, 2012 at 11:51:23PM +0800, Cong Wang wrote:
>> From: Cong Wang <xiyou.wangcong@gmail.com>
>>
>> It is scheduled to be removed in 3.6.
>
> This should go via Greg and linux-usb and you should put Pete Zaitcev on Cc.

Will do.

> I have a patch in my try doing this and removing the libusual which is obsolete
> since there is only one driver for USB storage.
> I would not remove the config option from all these defconfigs. Once this
> symbol is gone, it will vanish from defconfigs all by itself once they update
> their defconfigs and this patch does not clash with them.
>

Makes sense. I will send an updated patch.

Thanks!
