Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab2JVJeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:34:46 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58013 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab2JVJep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:34:45 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.255.235]
In-Reply-To: <CAK=WgbaBxyxzqxb6S98BdPTovS-SKueJBY+7JRqkX+GoQj=w9g@mail.gmail.com>
References: <20121006080758.GB29618@localhost> <CAK=WgbaBxyxzqxb6S98BdPTovS-SKueJBY+7JRqkX+GoQj=w9g@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 22 Oct 2012 11:34:24 +0200
Message-ID: <CAK=WgbZBjcOKWP8qtKVd+iecYb0-JL5oWZfCqoq0Kz8PPWF52Q@mail.gmail.com>
Subject: Re: [remoteproc:for-next 7/12] ERROR: "vring_del_virtqueue"
 [drivers/remoteproc/remoteproc.ko] undefined!
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Fengguang,

On Sat, Oct 6, 2012 at 11:57 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Sat, Oct 6, 2012 at 10:07 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>> ERROR: "vring_del_virtqueue" [drivers/remoteproc/remoteproc.ko] undefined!
>> ERROR: "register_virtio_device" [drivers/remoteproc/remoteproc.ko] undefined!
>> ERROR: "unregister_virtio_device" [drivers/remoteproc/remoteproc.ko] undefined!
>> ERROR: "vring_new_virtqueue" [drivers/remoteproc/remoteproc.ko] undefined!
>> ERROR: "vring_interrupt" [drivers/remoteproc/remoteproc.ko] undefined!
>> ERROR: "vring_transport_features" [drivers/remoteproc/remoteproc.ko] undefined!
>
> Thanks, Fengguang, I've pushed this patch to fix this:
...
> +       select VIRTIO_RING

Do you still see these issues with 3.7-rc2 ?

Rusty eliminated CONFIG_VIRTIO_RING recently, which makes this patch redundant.

I'm dropping this for now, please tell me if you still see any issue.

Thanks,
Ohad.
