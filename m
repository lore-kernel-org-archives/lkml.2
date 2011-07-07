Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab1GGM2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 08:28:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41290 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab1GGM2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 08:28:52 -0400
Subject: Re: [regression] 3.0-rc boot failure -- bisected to cd4ea6ae3982
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mahesh@linux.vnet.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        anton@samba.org, mingo@elte.hu, torvalds@linux-foundation.org
In-Reply-To: <20110707115531.GA21737@in.ibm.com>
References: <20110707102107.GA16666@in.ibm.com>
	 <1310036375.3282.509.camel@twins>  <20110707115531.GA21737@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Jul 2011 14:28:27 +0200
Message-ID: <1310041707.3282.569.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 17:25 +0530, Mahesh J Salgaonkar wrote:
> > I guess I'm asking is, do smaller P7 machines boot? And if so, is there
> > any difference except size?
> 
> Yes, the smaller P7 machine that I have with 20 CPUs and 2GB ram boots
> fine with 3.0.0-rc. 

That sounds like a single node machine. P7 comes as {4,6,8}*4 (16,24,32
cpus) per socket. And that 2G doesn't sound like much either.
