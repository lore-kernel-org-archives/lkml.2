Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab2F0F7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 01:59:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54729 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750994Ab2F0F7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 01:59:49 -0400
Message-ID: <1340776788.16533.44.camel@joe2Laptop>
Subject: Re: [PATCH] printk: Revert the buffered-printk() changes for now
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Kay Sievers <kay@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 26 Jun 2012 22:59:48 -0700
In-Reply-To: <20120627055255.GC14913@gmail.com>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
	 <20120622145402.8047a669.akpm@linux-foundation.org>
	 <20120623061313.GA21895@gmail.com> <1340452052.1784.40.camel@mop>
	 <20120625090933.GD24512@gmail.com>
	 <CAPXgP10E7HNDQ73ZFyb4EyDVBko2yXs8Rw0KOSKukGUpSBSz_g@mail.gmail.com>
	 <20120625140748.GB1301@gmail.com>
	 <1340635734.27036.327.camel@gandalf.stny.rr.com>
	 <20120625164033.GA14000@kroah.com> <20120627055255.GC14913@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 07:52 +0200, Ingo Molnar wrote:
> what is left are over 50,000 
> call sites of bragging and debugging code, occasionally massaged 
> to be somewhat user friendly.

Bragging.  Silly.  A _very_ small percent of
printks are "look at me" messages so I think that's
a ridiculously poor argument.

Most of the printks are announcement and error
logging notifications.


