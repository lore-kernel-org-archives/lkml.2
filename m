Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab0ERNHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 09:07:17 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40209 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab0ERNHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 09:07:14 -0400
Date: Tue, 18 May 2010 15:07:13 +0200
From: Jens Axboe <qemu@kernel.dk>
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Brian Jackson <iggy@theiggy.com>,
       virtualization@lists.linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH RFC] virtio_blk: Use blk-iopoll for host->guest notify
Message-ID: <20100518130712.GA25951@kernel.dk>
References: <1273870057-4287-1-git-send-email-stefanha@linux.vnet.ibm.com> <201005141730.57158.iggy@theiggy.com> <20100518080705.GA2467@stefan-thinkpad.transitives.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518080705.GA2467@stefan-thinkpad.transitives.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18 2010, Stefan Hajnoczi wrote:
> On Fri, May 14, 2010 at 05:30:56PM -0500, Brian Jackson wrote:
> > Any preliminary numbers? latency, throughput, cpu use? What about comparing 
> > different "weights"?
> 
> I am running benchmarks and will report results when they are in.

I'm very interested as well, I have been hoping for some more adoption
of this. I have mptsas and mpt2sas patches pending as well.

I have not done enough and fully exhaustive weight analysis, so note me
down for wanting such an analysis on virtio_blk as well.

-- 
Jens Axboe

