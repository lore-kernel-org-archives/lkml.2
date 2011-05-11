Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab1EKTqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:46:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:36654 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab1EKTqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:46:52 -0400
Subject: Re: [PATCH] sched: fix/optimise calculation of weight-inverse
From: Peter Zijlstra <peterz@infradead.org>
To: Stephan =?ISO-8859-1?Q?B=E4rwolf?= 
	<stephan.baerwolf@tu-ilmenau.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nikhil Rao <ncrao@google.com>, Mike Galbraith <efault@gmx.de>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4DCAC8FC.5060505@tu-ilmenau.de>
References: <4DCAB351.4010204@tu-ilmenau.de> <20110511162030.GA2638@elte.hu>
	 <1305132185.2914.251.camel@laptop>  <4DCAC8FC.5060505@tu-ilmenau.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 21:49:53 +0200
Message-ID: <1305143393.2914.255.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 19:35 +0200, Stephan Bärwolf wrote:
> Thus the "err" of the old way can become very large (up to about  2^31 ).
> And of course the new error increases with increasing weight, it is
> still alway
> smaller than the oldway err (because oldway inv converts to newway inv)...

Your table got white-space mungled, but I'll take your word for it. I'll
give the patch a spin tomorrow (without the weight==0 bits), since by
brain officially gave up for today ;-)

