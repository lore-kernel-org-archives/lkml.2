Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0EKQBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:01:30 -0400
Received: from smtp-out.google.com ([74.125.121.35]:39607 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab0EKQB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:01:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=XYHcV3tFsVDyqxgRHC+N9tTOuYG6hhOthb1qiWXSLg+I+qS4jXsLqrAw/X8UXD5Xg
	I1PpjK0ZE+D1jooADs3Wg==
MIME-Version: 1.0
In-Reply-To: <20100511155611.GG19192@ghostprotocols.net>
References: <AANLkTinsEANHEicdjOaE6jwUa0bVqH5PBwuGQ3_L59hT@mail.gmail.com>
	 <20100511150052.GE19192@ghostprotocols.net>
	 <1273590800.1810.19.camel@laptop>
	 <20100511155039.GF19192@ghostprotocols.net>
	 <1273593131.1810.42.camel@laptop>
	 <20100511155611.GG19192@ghostprotocols.net>
Date: Tue, 11 May 2010 18:01:24 +0200
Message-ID: <AANLkTikPIwvT4xD9Re2PMOnLa1NlRcdo9jD4Vt-L-ELk@mail.gmail.com>
Subject: Re: [RFC] perf: perf record sets inherit by default
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 5:56 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Tue, May 11, 2010 at 05:52:11PM +0200, Peter Zijlstra escreveu:
>> On Tue, 2010-05-11 at 12:50 -0300, Arnaldo Carvalho de Melo wrote:
>>
>> > Nope, see above.
>>
>> Ah, -p/-t might make sense to default to inherit off indeed.
>
> That is what Stephane wanted in the first place, right?
>
I was asking about the general behavior of the tool and
the contradictory meaning of the -i options.

perf record foo       -> default=inherit on, use -i to disable
perf record -t 1234  -> default=inherit off
perf record -p 1234  -> default=on, use -i to disable

What about that?
