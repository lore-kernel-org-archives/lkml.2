Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab2CGPta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:49:30 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41544 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2CGPt3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:49:29 -0500
MIME-Version: 1.0
In-Reply-To: <20120307152703.GD2348@linux.vnet.ibm.com>
References: <20120105135432.GA31450@elte.hu>
	<1327422312.7231.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20120124165312.GG2531@linux.vnet.ibm.com>
	<1327425208.7231.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20120124194140.GB2381@linux.vnet.ibm.com>
	<20120124232911.GA11327@linux.vnet.ibm.com>
	<20120307114410.GA4214@swordfish.minsk.epam.com>
	<CA+5PVA4CdtQYbJBvpoAa7iyWegBpJaDBcFfXpXYX=pARw_SBSA@mail.gmail.com>
	<20120307152703.GD2348@linux.vnet.ibm.com>
Date: Wed, 7 Mar 2012 10:49:26 -0500
Message-ID: <CA+5PVA7q03ZTLtFZH98KvtLbreSx65uGEBJmT02-vCHgogHaMg@mail.gmail.com>
Subject: Re: [GIT PULL] RCU changes for v3.3
From: Josh Boyer <jwboyer@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Andre@jasper.es
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 10:27 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Wed, Mar 07, 2012 at 09:09:39AM -0500, Josh Boyer wrote:
>> On Wed, Mar 7, 2012 at 6:44 AM, Sergey Senozhatsky
>> <sergey.senozhatsky@gmail.com> wrote:
>> > Hello,
>> > I just hit the same problem.
>> >
>> > Is this patch scheduled for 3.3 until release or will land during 3.4
>> > merge window?
>>
>> There are 3 patches in Paul's 3.4 queue, and another 9 of Steven Rostedt's
>> that fix this.  They'll wind up in 3.4.
>>
>> I looked at reverting the patch that adds this new warning and it doesn't
>> trivially revert.
>
> What are you based on?  I should be able to disable the warning for
> you easily enough.

3.3.  I think I tried reverting 00f49e5729af602deb559b0cf293a00b625e8636 and
it failed.  Then I locally commented out the WARN_ONCE in the functions which
got rid of that, but we still get a 'suspicious RCU usage' warning when
running powertop.  I gave up after that, since it all goes away if we disable
the debugging options and you have fixes queued for 3.4.

josh
