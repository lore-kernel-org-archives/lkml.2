Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab1H0BWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 21:22:13 -0400
Received: from tex.lwn.net ([70.33.254.29]:44999 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785Ab1H0BWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 21:22:09 -0400
Date: Fri, 26 Aug 2011 19:22:07 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>, Suresh Jayaraman <sjayaraman@suse.de>,
        lkml <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch]block: document blk_plug
Message-ID: <20110826192207.53c67c8f@bike.lwn.net>
In-Reply-To: <20110826152518.dc63fe89.akpm@linux-foundation.org>
References: <1311909215.15392.418.camel@sli10-conroe>
	<4E32A409.6060707@suse.de>
	<1312245970.15392.446.camel@sli10-conroe>
	<20110826152518.dc63fe89.akpm@linux-foundation.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011 15:25:18 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> I'm getting all excited about getting some blk_plug documentation!
> [...]
> Only we can't document it because we don't understand it.  Great.
> 
> c'mon Jens.   Talk to us?

Jens did give us a bit of documentation here:

	http://lwn.net/Articles/438256/

Not complete perhaps, but better than nothing...

jon
