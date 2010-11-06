Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0KFOod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 10:44:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49924 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab0KFOob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 10:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=B9ULk4JZK/9fGGmWTl79TWjd7kKjDDIyfo3VshEYsAqyiQJ1OavOLv4+QJqigih5Nh
         6oR3FZT6mKGYvIVMT2767/T6mn8g3e1F/7w9vFR5v1rU6JZ56AIf9Hsl/WLSUYyyIkk/
         Xj5HrHSeQ23AVBp6ovgKBnACGV2I5ANdlgL+4=
From: Francis Moreau <francis.moro@gmail.com>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Victor Jimenez <victor.javier@bsc.es>,
        Reid Kleckner <reid.kleckner@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: perf tools miscellaneous questions
References: <fa.SSgtQesEhEQa5DUYUwBV3fWtoV4@ifi.uio.no>
	<fa.dD5ur5Phqa1TLmYBE2NVKCQMjTw@ifi.uio.no>
	<fa.Xj1lA7n6nIJYL40CeRDpQzSKlfc@ifi.uio.no>
	<fa.xcyA+VzIXesq6qsPU6ADM4xdCKY@ifi.uio.no>
	<fa.MOg61Pcfdp2SJnwM2GFdOxP+xt0@ifi.uio.no>
	<fa.4sHfhlc/fMhpYgKda4IfUHZ7jMY@ifi.uio.no> <m2wros3pzf.fsf@gmail.com>
	<alpine.DEB.2.00.1011051000310.26020@cl320.eecs.utk.edu>
Date: Sat, 06 Nov 2010 15:44:24 +0100
In-Reply-To: <alpine.DEB.2.00.1011051000310.26020@cl320.eecs.utk.edu> (Vince
	Weaver's message of "Fri, 5 Nov 2010 10:02:01 -0400 (EDT)")
Message-ID: <m262wao6k7.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince Weaver <vweaver1@eecs.utk.edu> writes:

> On Fri, 5 Nov 2010, Francis Moreau wrote:
>
>> Victor Jimenez <victor.javier@bsc.es> writes:
>> 
>> [...]
>> 
>> > If you are measuring last level cache misses, I would recommend you to
>> > use a memory intensive application/benchmark instead of /bin/true, as
>> > otherwise there can be a significant variation between two runs.
>> 
>> I agree.
>> 
>> But still with intensive application, I got the same results:
>
>
> you're going to need to get your architectural manual for your processor 
> and use raw events (not the kernel default ones) if you really want to 
> find out what's going on.  A tool like libpfm4 can help change the names 
> to raw events for you.

Ouch that's a bit rude for a man page ;)

Specially since 'llc-loads-misses' is and should be self speaking.

OK, my cpu is described by:

,----
|   vendor_id	: GenuineIntel
|   cpu family	: 6
|   model	: 15
|   model name	: Intel(R) Core(TM)2 CPU         T5500  @ 1.66GHz
`----

Could you point out the best architecture manual for it which describe
the raw events ?

BTW, I'm wondering if event names are coherent across the different
architectures supported by Linux.

Thanks
-- 
Francis
