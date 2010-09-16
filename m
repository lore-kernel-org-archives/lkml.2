Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0IPOtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:49:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62053 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab0IPOtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:49:14 -0400
X-Authority-Analysis: v=1.1 cv=FR6uSFBUsHpo/LPxUdUfz19YCIdHKFi4UJmy4GdSgrg= c=1 sm=0 a=B_dWoPQBlxEA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=uBodtYNTShapA0tpeJ0A:9 a=ThQf8NeovQm7NfeKpph_i2u4uy8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Remaining BKL users, what to do
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnd Bergmann <arnd@arndb.de>, Jens Axboe <jaxboe@fusionio.com>
Cc: codalist@TELEMANN.coda.cs.cmu.edu, autofs@linux.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Christoph Hellwig <hch@infradead.org>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Petr Vandrovec <vandrove@vc.cvut.cz>, Anders Larsen <al@alarsen.net>,
        Jan Kara <jack@suse.cz>, Evgeniy Dushistov <dushistov@mail.ru>,
        Ingo Molnar <mingo@elte.hu>, netdev@vger.kernel.org,
        Samuel Ortiz <samuel@sortiz.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Hendry <andrew.hendry@gmail.com>
In-Reply-To: <201009161632.59210.arnd@arndb.de>
References: <201009161632.59210.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 16 Sep 2010 10:49:09 -0400
Message-ID: <1284648549.23787.26.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 16:32 +0200, Arnd Bergmann wrote:
> The big kernel lock is gone from almost all code in linux-next, this is
> the status of what I think will happen to the remaining users:

> kernel/trace/blktrace.c:
> 	Should be easy. Ingo? Steven?
> 

Jens,

Git blame shows this to be your code (copied from block/blktrace.c from
years past).

Is the lock_kernel() needed here? (although Arnd did add it in 62c2a7d9)

-- Steve


