Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab0EKPzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:55:51 -0400
Received: from smtp-out.google.com ([74.125.121.35]:37462 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0EKPzt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:55:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=BKFmwlsxqILFPgB0wU0ijRPC7Mw7TUhfOEfas/m9zjY+qny+VpPjq5zmi1KILR4G3
	TiF2b2rekDyV8DwaC1FwA==
MIME-Version: 1.0
In-Reply-To: <1273593131.1810.42.camel@laptop>
References: <AANLkTinsEANHEicdjOaE6jwUa0bVqH5PBwuGQ3_L59hT@mail.gmail.com>
	 <20100511150052.GE19192@ghostprotocols.net>
	 <1273590800.1810.19.camel@laptop>
	 <20100511155039.GF19192@ghostprotocols.net>
	 <1273593131.1810.42.camel@laptop>
Date: Tue, 11 May 2010 17:55:44 +0200
Message-ID: <AANLkTin5a3ghAUzFiQFoWNA1g9v-yFFC7uwyJEQ3zzu0@mail.gmail.com>
Subject: Re: [RFC] perf: perf record sets inherit by default
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 5:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-05-11 at 12:50 -0300, Arnaldo Carvalho de Melo wrote:
>
>> Nope, see above.
>
> Ah, -p/-t might make sense to default to inherit off indeed.
>
>
I would rather think that -p would inherit but not -t.
If I attach to a multi-threaded app with -p, I'd like all threads monitored.
But if I use -t to point to a specific thread within a process, then most
likely I care only about that thread.




-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
