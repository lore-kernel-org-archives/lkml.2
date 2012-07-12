Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626Ab2GLXqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:46:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35867 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759595Ab2GLXqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:46:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120712233645.GG20167@google.com>
References: <1341859315-17759-7-git-send-email-tj@kernel.org>
	<20120712130648.GA19214@localhost>
	<20120712170519.GA20167@google.com>
	<20120712214514.GD20167@google.com>
	<CA+8MBb+ghRpmtrk=t5-6MqrPMZt+a69UoAWaubyKBeptGdBrWA@mail.gmail.com>
	<20120712223221.GF20167@google.com>
	<CA+8MBbJQVF3-CUU8MPWgm7OifD-C8=U2=uPF3JH9XNvAWVAX6A@mail.gmail.com>
	<20120712233645.GG20167@google.com>
Date: Thu, 12 Jul 2012 16:46:12 -0700
Message-ID: <CA+8MBbJbjKmH29Yapih9anxXTsNy7C2TWgtnFX3-Gm6cNyCY3g@mail.gmail.com>
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

On Thu, Jul 12, 2012 at 4:36 PM, Tejun Heo <tj@kernel.org> wrote:
> The debug patch didn't do anything for the bug itself.  I suppose it's
> timing dependent and doesn't always happen (it never reproduces here
> for some reason).  Can you please repeat several times and see whether
> the warning can be triggered?

Still hasn't come back in three reboots.  I have to leave now, can continue
tomorrow.

-Tony
