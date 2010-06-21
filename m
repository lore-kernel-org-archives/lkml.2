Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab0FUOzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:55:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:45935 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538Ab0FUOzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:55:14 -0400
Subject: Re: [patch 11/33] fs: dcache scale subdirs
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>, John Kacur <jkacur@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100621144806.GC31679@laptop>
References: <20090904065142.114706411@nick.local0.net>
	 <20090904065535.609317663@nick.local0.net>
	 <1276787615.27822.426.camel@twins> <20100617165329.GA6138@laptop>
	 <1277127322.1875.516.camel@laptop>  <20100621144806.GC31679@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 21 Jun 2010 16:55:03 +0200
Message-ID: <1277132103.1875.519.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 00:48 +1000, Nick Piggin wrote:
> > Right, so I was staring at the -rt splat, so its John who created that
> > wreckage?
> 
> It was, but apparently they saw an RCU bug there somewhere and hit it
> with the big hammer. I haven't been able to reproduce it on a non-rt
> kernel yet, and I see yet why RCU is not good enough here.

John, could you describe the failure you spotted?
