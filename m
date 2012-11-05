Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2KEWl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:41:59 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52233 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab2KEWl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:41:58 -0500
MIME-Version: 1.0
In-Reply-To: <0000013ad125d4dd-180f5394-cb25-4b59-b6e0-8e9504564cf6-000000@email.amazonses.com>
References: <20121029202711.062749374@goodmis.org>
	<0000013ac180f152-79f05c71-4d38-43b0-9b62-8a71c00dfda7-000000@email.amazonses.com>
	<1351867045.4004.141.camel@gandalf.local.home>
	<0000013ac1a58555-bea33420-d101-4e86-abc5-11dd6863b7a8-000000@email.amazonses.com>
	<20121102183544.GZ3027@linux.vnet.ibm.com>
	<0000013ac2c4f47a-d21f2685-6660-4d02-872d-581d203285a0-000000@email.amazonses.com>
	<20121102204157.GE3027@linux.vnet.ibm.com>
	<1351889510.4004.149.camel@gandalf.local.home>
	<20121103020845.GF3027@linux.vnet.ibm.com>
	<0000013ad125d4dd-180f5394-cb25-4b59-b6e0-8e9504564cf6-000000@email.amazonses.com>
Date: Mon, 5 Nov 2012 23:41:57 +0100
Message-ID: <CAFTL4hxnZezg6b+HhNtiE7stku2NB8C1eh-9q18POy3GMQhuig@mail.gmail.com>
Subject: Re: [PATCH 00/32] [RFC] nohz/cpuset: Start discussions on nohz CPUs
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/5 Christoph Lameter <cl@linux.com>:
> On Fri, 2 Nov 2012, Paul E. McKenney wrote:
>
>> On Fri, Nov 02, 2012 at 04:51:50PM -0400, Steven Rostedt wrote:
>> > On Fri, 2012-11-02 at 13:41 -0700, Paul E. McKenney wrote:
>> >
>> > > The no-CBs mask would be read-only for some time -- changed only at
>> > > boot.  Longer term, I hope to allow run-time modification, but...
>> >
>> > but what? You're not looking to retire already are you? ;-)
>>
>> Not for a few decades.  ;-)
>>
>> But let's add the no-CBs mask to sysfs when I add the ability to run-time
>> modify that mast.
>
> Well we are creating a user ABi with the boot time option. It would be
> best to get it right out of the door.

I believe that a static setting through a boot option is a nice first
step already. Runtime tuning may involve dynamic migration and other
headaches. The nocb patch is tricky enough to review ;)
