Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab2ECT4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 15:56:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:45695 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab2ECT4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 15:56:06 -0400
Message-ID: <1336074950.6509.4.camel@twins>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 21:55:50 +0200
In-Reply-To: <CAPXgP13En_6AXd0NpEsDWWWC6=44_tYKajkxACnYS-=x9AEA8Q@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <1336074483.6509.3.camel@twins>
	 <CAPXgP13En_6AXd0NpEsDWWWC6=44_tYKajkxACnYS-=x9AEA8Q@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 21:54 +0200, Kay Sievers wrote:
> On Thu, May 3, 2012 at 9:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2012-05-03 at 02:29 +0200, Kay Sievers wrote:
> >> + * This is printk(). It can be called from any context. We want it to work.
> >
> > This is not true..
> 
> I did not add that, it's just 'diff' that moves this hunk while adding
> stuff before it. It's the same text as in the current code:

Sure, but its still not true.
