Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab2FZASg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:18:36 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45570 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757244Ab2FZASf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:18:35 -0400
Message-ID: <1340669914.3359.11.camel@joe2Laptop>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "kay.sievers" <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Mon, 25 Jun 2012 17:18:34 -0700
In-Reply-To: <20120625150722.8cd4f45d.akpm@linux-foundation.org>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com>
	 <20120625150722.8cd4f45d.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 15:07 -0700, Andrew Morton wrote:
> The core printk code is starting to make one think of
> things like "cleansing with fire".

I've been waiting to have the code settle a bit before
restructuring/refactoring it.

I've got a tree with printk.c moved to kernel/printk/ and
broken up into what I think are more sensible bits.

Maybe I'll submit it in awhile.  I think it's probably
better to wait until after 3.6-rc though.

> must.. stop.. thinking.. about.. fire..

Please remember to aim before firing.

cheers, Joe

