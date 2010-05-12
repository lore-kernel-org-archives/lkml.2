Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab0ELRNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:13:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62775 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab0ELRND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:13:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gVvXPBOZi4PRjR6fY1FU3ggiEEgSZpRBpQATVFdU/QUaJAUgDZ6lCyFrQTHGIJuoiL
         4ONtQCAWBmbbqTuEDGIg5sUhc7KeREXByfsGn5LlkCJlAuuEemVIKw4GQE3skMvLKPxs
         EyuPC48xJoNQXxxVDo5ZdkTs34IOCwUDWecS0=
MIME-Version: 1.0
In-Reply-To: <20100512144811.GA5405@nowhere>
References: <AANLkTilJLcdfK-vgqGdXyaZ_bQ1BDFmQl619egtGAA4i@mail.gmail.com>
	 <20100511213625.GD5422@nowhere>
	 <AANLkTikumkBKwYTYIK63mT2i_hI4SAo-Eua0cx9OCHnD@mail.gmail.com>
	 <20100512144811.GA5405@nowhere>
Date: Wed, 12 May 2010 19:13:00 +0200
Message-ID: <AANLkTim0fEoUXav-KmXPEk67vZVhn-FnpnbLOHpI2HDF@mail.gmail.com>
Subject: Re: [RFC] PyTimechart
From: Pierre Tardy <tardyp@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       mathieu.desnoyers@efficios.com, arjan@infradead.org,
       ziga.mahkovec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 4:48 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Wed, May 12, 2010 at 03:37:27PM +0200, Pierre Tardy wrote:
>> > Plugging to the scripting API is really easy, run:
>> >
>> >        $ perf timechart record
>> >        $ sudo ./perf trace -g python
>> >        generated Python script: perf-trace.py
>>
>> This is something that I want to try since I saw the perf scripting
>> patch, thanks for the recipe, I'll look at it in the next few days.
>>
>> The next problem is that perf timechart record is frozen on the number
>> of event it records.
>
>
>
> What do you mean? That it can't do incremental records or so?
> It's supported by perf record, may be not by perf timechart but
> that would be a matter of a little patch.

I mean that perf timechart record is implemented as an hardcoded perf
record call.
Typically, user wants to add is own events for pytimechart to display
them in a generic manner.
I agree this is a trivial change.


>
> Why not starting with a release that does the same things
> than timechart and trying to integrate the rest incrementally?
Yes, I'll see what I can do.

> The code I'm looking at here doesn't look dirty to me at a glance:
> http://gitorious.org/pytimechart/pytimechart/trees/master
That's because you did not read between the lines ;-)
The display core needs to be simplified.


Regards,
Pierre
