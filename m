Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab2GIRPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:15:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59622 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752547Ab2GIRPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:15:08 -0400
Message-ID: <1341854107.6118.11.camel@joe2Laptop>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Michael Neuling <mikey@neuling.org>,
        linuxppc-dev@ozlabs.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Mon, 09 Jul 2012 10:15:07 -0700
In-Reply-To: <20120709170956.GB24728@kroah.com>
References: <CAPXgP11+j+fDexHHmAZbBBidtrydrpWeh3DGWOhkuoybNj9skA@mail.gmail.com>
	 <1341492628.834.3.camel@mop> <30233.1341535279@neuling.org>
	 <CAPXgP12_F_H2XPpo2wFmb-u3jBdV__=h67R-LVYbqHuLh7tqLg@mail.gmail.com>
	 <29711.1341545979@neuling.org> <30343.1341546469@neuling.org>
	 <CAPXgP13_cQUQLE4RSjACTzj28Pn6r3ZaPhjch2U+uwgi7YKcWA@mail.gmail.com>
	 <CAPXgP10JthGjZyqD6gqn2n1rPu1uP+=mem_T-iOritXAQMstRQ@mail.gmail.com>
	 <21892.1341608647@neuling.org> <1341770155.1011.27.camel@mop>
	 <20120709170956.GB24728@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 10:09 -0700, Greg Kroah-Hartman wrote:
> is it ok if we
> just merge this in 3.6-rc1 and backport it to 3.5.1 if it looks ok
> there?

I'd prefer it get accepted now so that refactoring the
printk subsystem could occur for 3.6.

Another option would be to revert all Kay's changes to the
printk subsystem, fix this in 3.6 and refactor in 3.7.

