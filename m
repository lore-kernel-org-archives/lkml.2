Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934863Ab0EZXNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:13:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35598 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab0EZXNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:13:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=LRxH2iOmp2oivaQb5XbWWiBeP+slFVhY/85DfFlo6G/5KdwnN+59m9lkVdk2tteBu
	VhBXN9P9L/3I/GcpKy57Q==
MIME-Version: 1.0
In-Reply-To: <20100526205002.GE9874@ghostprotocols.net>
References: <1274664671-27385-1-git-send-email-acme@infradead.org>
	<AANLkTil5WtBnMQt1odjEgmWHOuuKxb4AIyuBLAqOiUSg@mail.gmail.com>
	<20100526005531.GA9874@ghostprotocols.net>
	<AANLkTim-xv9mNEwGCueV47AoKh6AXbrdbTdCEwZHaEHJ@mail.gmail.com>
	<20100526182351.GB9874@ghostprotocols.net>
	<AANLkTimOEUKYXzdMOiWE6gRxR7vJX36VscdLjRroqGLq@mail.gmail.com>
	<20100526193255.GC9874@ghostprotocols.net>
	<AANLkTinxVsp1qtfqjlwl-ngrcD9IBDg6GoBnAk07ABuo@mail.gmail.com>
	<20100526203315.GD9874@ghostprotocols.net>
	<AANLkTimBC83Z8lSD8Drfpefl1D8Fpx-hYuQaZx4RyvSG@mail.gmail.com>
	<20100526205002.GE9874@ghostprotocols.net>
Date: Thu, 27 May 2010 01:13:24 +0200
Message-ID: <AANLkTilDGRUQXZZhFKugOjXvWrb-mHyVTSBPSiWaJ0XH@mail.gmail.com>
Subject: Re: [GIT PULL 0/2] perf annotate fix and report improvoment
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       mingo@elte.hu, Peter Zijlstra <peterz@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 10:50 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Wed, May 26, 2010 at 10:40:24PM +0200, Stephane Eranian escreveu:
>> On Wed, May 26, 2010 at 10:33 PM, Arnaldo Carvalho de Melo
>> > I just tried it here with:
>> >
>> > [root@emilia linux-2.6-tip]# perf report -d libc-2.12.so
>> > [root@emilia linux-2.6-tip]# perf annotate -d libc-2.12.so
>> >
>> > with
>> >
>> > [root@emilia linux-2.6-tip]# cat ~/.perfconfig
>> > [tui]
>> >
>> >        report = on
>> >        annotate = on
>> > [root@emilia linux-2.6-tip]#
>> >
>> > And it works as expected.
>
>> I did not explain my testcase enough ;-<
>>
>> With TUI, I started from perf report -i perf.data, then chose to zoom into
>> the noploop symbol.
>
> You can zoom into DSOs and threads, additionally you can Annotate
> symbols, so you mean that annotating the 'noploop' in the 'noploop' DSO
> didn't work?
>
Yes, it does not show me the assembly.

> Lets try this offline thing ourselves, can you please put the
> perf.data.tar.bz2 and the perf.data files somewhere I can grab? So that
> I can try to do these operations here and figure out the problem :-)
>
> I guess there is nothing sensitive in those files, lemme know if making
> them available is not an option and I'll try other ways to get this
> fixed.
>
I will send you the files in a private email.
