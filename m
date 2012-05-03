Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab2ECTzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 15:55:41 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:57406 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758255Ab2ECTzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 15:55:20 -0400
MIME-Version: 1.0
In-Reply-To: <1336074483.6509.3.camel@twins>
References: <1336004953.4240.9.camel@mop> <1336074483.6509.3.camel@twins>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 3 May 2012 21:54:58 +0200
Message-ID: <CAPXgP13En_6AXd0NpEsDWWWC6=44_tYKajkxACnYS-=x9AEA8Q@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 9:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-05-03 at 02:29 +0200, Kay Sievers wrote:
>> + * This is printk(). It can be called from any context. We want it to work.
>
> This is not true..

I did not add that, it's just 'diff' that moves this hunk while adding
stuff before it. It's the same text as in the current code:

  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=kernel/printk.c;h=b663c2c95d3922e4c080e8974c09c6ce99b4355f;hb=HEAD#l729

Kay
