Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979Ab0EYOgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 10:36:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44087 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab0EYOgw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 10:36:52 -0400
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 icedove-bin/5449
From: Peter Zijlstra <peterz@infradead.org>
To: piotr@hosowicz.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4BFBE004.5060101@example.com>
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>
	 <20100525094347.GA7881@elte.hu>  <4BFB9F0A.9040803@example.com>
	 <1274781655.5882.765.camel@twins> <4BFBA0F8.9090908@example.com>
	 <4BFBA6A2.4070405@example.com> <4BFBDAF3.3020504@example.com>
	 <4BFBE004.5060101@example.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 16:36:37 +0200
Message-ID: <1274798197.5882.1491.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 16:34 +0200, Piotr Hosowicz wrote:
> > Not exactly. I looked into the syslog. I's much better, but I rebooted
> > to single user mode to rebuild nvidia driver (new beta version) and I
> > see same error (BUG ... code: ???) on shuting down, mentioning sync,
> > umount and finally shutdown.
> 
> Sorry, reversed order - shutdown, umount, finally sync. 

Could you post the full splat?

I'd be very surprised if its the same thing.
