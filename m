Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604Ab2EIRZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:25:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:41263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760570Ab2EIRZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:25:42 -0400
Message-ID: <1336584331.2527.63.camel@twins>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Igor Mammedov <imammedo@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Date: Wed, 09 May 2012 19:25:31 +0200
In-Reply-To: <20120509172403.GB8135@gmail.com>
References: <1336566096.2527.30.camel@twins>
	 <1336566644.2527.33.camel@twins> <1336570043.2527.38.camel@twins>
	 <20120509133607.GA26124@gmail.com> <1336571049.2527.43.camel@twins>
	 <1336571947.2527.47.camel@twins> <20120509141528.GA3623@gmail.com>
	 <1336577562.2527.58.camel@twins> <20120509154116.GC2653@gmail.com>
	 <1336579592.2527.60.camel@twins> <20120509172403.GB8135@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 19:24 +0200, Ingo Molnar wrote:
> I don't think that's a significant limitation, because it's 
> fixed width anyway. So if this works then this would be a pretty 
> good and simple to use solution. 

Not quite following, there's nothing fixed width about
bitmap_scnlistprintf() output.
