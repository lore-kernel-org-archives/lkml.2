Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab1BACv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 21:51:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751789Ab1BACv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 21:51:28 -0500
MIME-Version: 1.0
In-Reply-To: <20110201021831.GB2158@linux.vnet.ibm.com>
References: <20110112150740.77dde58c@kryten> <1295288253.30950.280.camel@laptop>
 <smp-call-function-peter-reply@mdm.bga.com> <smp-call-function-move-writes@mdm.bga.com>
 <1296145360.15234.234.camel@laptop> <smp-call-function-list-race@mdm.bga.com>
 <smp-call-function-list-race-fix@mdm.bga.com> <1296508677.26581.84.camel@laptop>
 <1296519764.2349.325.camel@pasglop> <AANLkTikEo4Bbqn27nCO_xjwEuy9rkoqBjoOb_HeGw18D@mail.gmail.com>
 <20110201021831.GB2158@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 1 Feb 2011 12:43:56 +1000
Message-ID: <AANLkTimb7bpTa0fO2VU4pSxO-a3-eQNA6zA_ikAReXsQ@mail.gmail.com>
Subject: Re: call_function_many: fix list delete vs add race
To: paulmck@linux.vnet.ibm.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>, Milton Miller <miltonm@bga.com>,
        akpm@linux-foundation.org, Anton Blanchard <anton@samba.org>,
        xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, jaxboe@fusionio.com,
        npiggin@gmail.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 12:18 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> Documentation/memory-barriers.txt specifies this.

Good, so it really is documented, with both cases explicitly mentioned.

That said, I do think that if your memory ordering is much weaker than
x86, you are going to see bugs that most testers don't see, and it
simply might not be worth it.

               Linus
