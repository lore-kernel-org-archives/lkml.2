Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161841Ab2GLXgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:36:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63399 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161720Ab2GLXgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:36:51 -0400
Date: Thu, 12 Jul 2012 16:36:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, joshhunt00@gmail.com, axboe@kernel.dk,
        rni@google.com, vgoyal@redhat.com, vwadekar@nvidia.com,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, swhiteho@redhat.com, bpm@sgi.com,
        elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH 6/6] workqueue: reimplement WQ_HIGHPRI using a separate
 worker_pool
Message-ID: <20120712233645.GG20167@google.com>
References: <1341859315-17759-7-git-send-email-tj@kernel.org>
 <20120712130648.GA19214@localhost>
 <20120712170519.GA20167@google.com>
 <20120712214514.GD20167@google.com>
 <CA+8MBb+ghRpmtrk=t5-6MqrPMZt+a69UoAWaubyKBeptGdBrWA@mail.gmail.com>
 <20120712223221.GF20167@google.com>
 <CA+8MBbJQVF3-CUU8MPWgm7OifD-C8=U2=uPF3JH9XNvAWVAX6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbJQVF3-CUU8MPWgm7OifD-C8=U2=uPF3JH9XNvAWVAX6A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tony.

On Thu, Jul 12, 2012 at 04:24:47PM -0700, Tony Luck wrote:
> On Thu, Jul 12, 2012 at 3:32 PM, Tejun Heo <tj@kernel.org> wrote:
> > Can you please try the following debug patch instead?  Yours is
> > different from Fengguang's.
> 
> New dmesg from mext-20120712 + this new patch (instead of previous one)
> 
> [Note - I see some XXX traces, but no WARN_ON stack dump this time]

The debug patch didn't do anything for the bug itself.  I suppose it's
timing dependent and doesn't always happen (it never reproduces here
for some reason).  Can you please repeat several times and see whether
the warning can be triggered?

Thank you very much!

-- 
tejun
