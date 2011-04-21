Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab1DUD2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 23:28:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35321 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab1DUD2K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 23:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bzfMRRG/ERlkVL+GETViVODHjv17Tu7kZhlwq9WKfftcXBuAkjPQfG+yXA+TX6mwEq
         Wt8AQw++qf1YGmnIuC4lmmuLlFGJvmnmV6i9vlnU9K8kCsmAabcqnNUOkHwZbYYZgmJi
         XhuGaGIxSidxWHv9mK92Q/Sds5CwT8PtERHqM=
MIME-Version: 1.0
In-Reply-To: <20110421024648.GA24898@home.goodmis.org>
References: <BANLkTin7=j8-feeJw5fqDsMd9BYrq09KbQ@mail.gmail.com>
 <1302024458.2225.1350.camel@twins> <BANLkTinU5s8FgC9acCPcQqDRBnwi4EqA2g@mail.gmail.com>
 <1302077959.2225.1378.camel@twins> <BANLkTimHwt=q4K9uMNX4kR6Q8LJhHHSysw@mail.gmail.com>
 <BANLkTimP-uhj7PQqgvpnedy_y9sQga99ug@mail.gmail.com> <BANLkTi=KZyi-e02Rc=agnVDOk+4=VLdZ-w@mail.gmail.com>
 <BANLkTi=BQVjXRLNxiCU0xaYrDShtRgiC6Q@mail.gmail.com> <20110421024648.GA24898@home.goodmis.org>
From: Hui Zhu <teawater@gmail.com>
Date: Thu, 21 Apr 2011 11:27:50 +0800
Message-ID: <BANLkTinWoPQ+8kz6A4qCvYqEcj=FhzvBDw@mail.gmail.com>
Subject: Re: KGTP (Linux Kernel debugger and tracer) 20110405 release
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dongdong Deng <libfetion@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 10:46, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, Apr 08, 2011 at 04:25:28PM +0800, Hui Zhu wrote:
>> After a discussion with Dongdong, I think I have different idea with that.
>>
>> 1. I don't want change the current interface of kgtp.  Because a proc
>> interface is very simple and stable interface.
>> And with proc, kgtp can very easy connect with GDB without Kernel
>
> Can you use the debugfs interface instead of proc. Proc is too
> overloaded as is, and debugfs seems to be a perfect match in this case.
>
> -- Steve

Hi Steve,

I really agree with what you said. I will change it.  Thank a lot.

Best,
Hui

>
>> help.  Please see
>> https://code.google.com/p/kgtp/wiki/HOWTO#Make_GDB_connect_to_gtp and
>> https://code.google.com/p/kgtp/wiki/HOWTO#Offline_debug
>>
>> 2. I don't want remove the kprobe.  Because what I want kgtp is to be
>> a Linux Kernel tracepoint interface with gdb.  I will add other
>> tracepoint like TRACE_EVENT.
>> And move it to gdb breakpoint is too far away from it.  And it is too
>> much depend on kgdb.
>>
>> Of course, I am very happy to share the GDB rsp tracepoint parse code
>> with kgdb to make it support gdb tracepoint.
>> Trust me, My code is more clear than the doc of GDB.  :)
>>
>
