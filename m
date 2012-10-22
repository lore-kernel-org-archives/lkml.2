Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2JVJrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 05:47:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:56809 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab2JVJrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 05:47:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,628,1344236400"; 
   d="scan'208";a="207397428"
Date: Mon, 22 Oct 2012 17:47:28 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [remoteproc:for-next 7/12] ERROR: "vring_del_virtqueue"
 [drivers/remoteproc/remoteproc.ko] undefined!
Message-ID: <20121022094728.GA9875@localhost>
References: <20121006080758.GB29618@localhost>
 <CAK=WgbaBxyxzqxb6S98BdPTovS-SKueJBY+7JRqkX+GoQj=w9g@mail.gmail.com>
 <CAK=WgbZBjcOKWP8qtKVd+iecYb0-JL5oWZfCqoq0Kz8PPWF52Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=WgbZBjcOKWP8qtKVd+iecYb0-JL5oWZfCqoq0Kz8PPWF52Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 11:34:24AM +0200, Ohad Ben-Cohen wrote:
> Hello Fengguang,
> 
> On Sat, Oct 6, 2012 at 11:57 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> > On Sat, Oct 6, 2012 at 10:07 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> >> ERROR: "vring_del_virtqueue" [drivers/remoteproc/remoteproc.ko] undefined!
> >> ERROR: "register_virtio_device" [drivers/remoteproc/remoteproc.ko] undefined!
> >> ERROR: "unregister_virtio_device" [drivers/remoteproc/remoteproc.ko] undefined!
> >> ERROR: "vring_new_virtqueue" [drivers/remoteproc/remoteproc.ko] undefined!
> >> ERROR: "vring_interrupt" [drivers/remoteproc/remoteproc.ko] undefined!
> >> ERROR: "vring_transport_features" [drivers/remoteproc/remoteproc.ko] undefined!
> >
> > Thanks, Fengguang, I've pushed this patch to fix this:
> ...
> > +       select VIRTIO_RING
> 
> Do you still see these issues with 3.7-rc2 ?
> 
> Rusty eliminated CONFIG_VIRTIO_RING recently, which makes this patch redundant.
> 
> I'm dropping this for now, please tell me if you still see any issue.

Ohad, I'm no longer seeing these errors. :)

Thanks,
Fengguang
