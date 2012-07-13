Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030583Ab2GMRvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 13:51:36 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53653 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab2GMRvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 13:51:33 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBbJbjKmH29Yapih9anxXTsNy7C2TWgtnFX3-Gm6cNyCY3g@mail.gmail.com>
References: <1341859315-17759-7-git-send-email-tj@kernel.org>
	<20120712130648.GA19214@localhost>
	<20120712170519.GA20167@google.com>
	<20120712214514.GD20167@google.com>
	<CA+8MBb+ghRpmtrk=t5-6MqrPMZt+a69UoAWaubyKBeptGdBrWA@mail.gmail.com>
	<20120712223221.GF20167@google.com>
	<CA+8MBbJQVF3-CUU8MPWgm7OifD-C8=U2=uPF3JH9XNvAWVAX6A@mail.gmail.com>
	<20120712233645.GG20167@google.com>
	<CA+8MBbJbjKmH29Yapih9anxXTsNy7C2TWgtnFX3-Gm6cNyCY3g@mail.gmail.com>
Date: Fri, 13 Jul 2012 10:51:32 -0700
Message-ID: <CA+8MBbLWxf4=95BHoVC4h-TM5S393Hhttx2BgdD-vUtHxpiYnA@mail.gmail.com>
Subject: Re: [PATCH 6/6] workqueue: reimplement WQ_HIGHPRI using a separate worker_pool
From: Tony Luck <tony.luck@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, joshhunt00@gmail.com, axboe@kernel.dk,
        rni@google.com, vgoyal@redhat.com, vwadekar@nvidia.com,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, swhiteho@redhat.com, bpm@sgi.com,
        elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 4:46 PM, Tony Luck <tony.luck@gmail.com> wrote:
> Still hasn't come back in three reboots.  I have to leave now, can continue
> tomorrow.

Tired of rebooting ... seems that it is very hard to hit this with
this patch :-(

-Tony
