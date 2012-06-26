Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab2FZRBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 13:01:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58560 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348Ab2FZRA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 13:00:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120626165855.GA1851@kroah.com>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com> <20120625150722.8cd4f45d.akpm@linux-foundation.org>
 <20120625235531.GB3652@kroah.com> <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
 <20120626002307.GA4389@kroah.com> <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
 <1340726856.977.6.camel@mop> <20120626165855.GA1851@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 26 Jun 2012 19:00:38 +0200
Message-ID: <CAPXgP132AM9_3KryDc0cE+cKd-Q65wpGRkSzHaMvOGLM3AsrHg@mail.gmail.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 6:58 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Jun 26, 2012 at 06:07:36PM +0200, Kay Sievers wrote:
>> On Mon, 2012-06-25 at 18:40 -0700, Linus Torvalds wrote:
>> > On Mon, Jun 25, 2012 at 5:56 PM, Kay Sievers <kay@vrfy.org> wrote:
>> > >
>> > > Buffering has nice effects though:
>> > > It makes continuation lines appear as one record in the buffer, not as
>> > > n individual prints with n headers.
>> >
>> > As I already mentioned, buffering for *logging* is different from
>> > buffering for *printing*.
>> >
>> > I think it might be a great idea to buffer for logging in order to
>> > generate one individual buffer record there.
>> >
>> > But it needs to be printed as it is generated.
>>
>> That's a good idea.
>>
>> Something like this could work - only minimally tested at this moment.
>
> Hm, this doesn't boot for me, just hangs at startup :(

You have that patch against your tree? Let me try that, maybe it
conflicts with one of the patches there ...

Kay
