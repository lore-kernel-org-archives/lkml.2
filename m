Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab1DFFyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 01:54:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48012 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab1DFFya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 01:54:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=iNwn5yPvhBD44Rtw00f0Lx1luVkvESZBZ37w6U7ajB8Tq60VqzQ0TgpKKS7+Lczc8i
         tTsQ9AZ29Fr0MN8wH9gnieyiQHa8zNEay4FxxK++E8ePxyY5rCN7OKxLgsVEs5U6MPWB
         z/CjEPdBbR7O53Qj8lROqT6QJ52ja5hwswXpo=
MIME-Version: 1.0
In-Reply-To: <1302024458.2225.1350.camel@twins>
References: <BANLkTin7=j8-feeJw5fqDsMd9BYrq09KbQ@mail.gmail.com> <1302024458.2225.1350.camel@twins>
From: Hui Zhu <teawater@gmail.com>
Date: Wed, 6 Apr 2011 13:54:10 +0800
Message-ID: <BANLkTinU5s8FgC9acCPcQqDRBnwi4EqA2g@mail.gmail.com>
Subject: Re: KGTP (Linux Kernel debugger and tracer) 20110405 release
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Jason Wessel <jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 01:27, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-04-05 at 19:59 +0800, Hui Zhu wrote:
>> KGTP is a realtime and lightweight Linux Kernel GDB debugger and
>> tracer that use Kprobe.
>>
>> It make Linux Kernel supply a GDB remote debug interface. Then GDB in
>> current machine or remote machine(see "Make GDB connect to gtp") can
>> debug Linux through GDB tracepoint without stop the Linux Kernel.
>> And even if the board doesn't have GDB on it and doesn't have
>> interface for remote debug. It can debug the Linux Kernel use offline
>> debug (See "Offline debug").
>
> So this leaves me wondering how this is different from the existing
> KGDB, if its different why its not reusing/extending the existing
> infrastructure.
>
>
>

Hi Peter,

This is a good question.

The KGTP is completely different with KGDB.  It will not supply simple
gdbrsp debug interface to user.  It just supply  interface between the
kernel tracepoint(Now, just support kprobe, will add others later) and
GDB tracepoint function.

So user can debug and trace Linux kernel with GDB without stop the
Linux Kernel (So the GDB can running on this Kernel).  It is a trace
tools and debug tools.

Thanks,
Hui
