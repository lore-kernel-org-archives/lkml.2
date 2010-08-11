Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab0HKTGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:06:39 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:47595 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755422Ab0HKTGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:06:37 -0400
Message-ID: <4C62F4BD.9030605@vmware.com>
Date: Wed, 11 Aug 2010 12:06:37 -0700
From: Michael Snyder <msnyder@vmware.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Thiago Jung Bauermann <thiago.bauermann@gmail.com>
CC: Hui Zhu <teawater@gmail.com>, "gdb@sourceware.org" <gdb@sourceware.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux Kernel GDB tracepoint module demo release
References: <AANLkTi=4_QnAyY+zcuXwVpPkESjpF7yfMb1RunMQaK7f@mail.gmail.com> <1281553430.32376.2.camel@hactar>
In-Reply-To: <1281553430.32376.2.camel@hactar>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thiago Jung Bauermann wrote:
> Hi Hui,
> 
> On Thu, 2010-08-12 at 00:34 +0800, Hui Zhu wrote:
>> GDB Tracepoint (http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoints.html)
>> is new feature that make GDB can debug real-time program.
>> I think this feature is very fit for debug Linux Kernel.  So I make a
>> lkm to make kernel support it. You can get it in
>> https://code.google.com/p/kgtp/
> 
> Jim Blandy worked on GDB tracepoint support for the kernel too. I don't
> know how his work compares to yours, you might be interested in having a
> look:
> 
> http://www.red-bean.com/trac/tracepoints/
> 

There's also the LTTng project: http://lttng.org/


