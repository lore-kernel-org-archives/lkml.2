Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab0K3J0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 04:26:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38614 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab0K3J0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 04:26:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=VQHrsqb4lxNklSC2kITsquVVuw0FVEFInNStM1Lq6Be5dx1E6d2ZYIxrfjZFGKbN7B
         dlNo7x6s++20BTxdsARkKKQjVXC009OIps5dfrUfTWbUmRpjMzr3k1JotiNhbloxpeQG
         UeAHywFcbBNUiDH7Xyh2pBuENFZUnnyCJswIM=
Date: Tue, 30 Nov 2010 17:31:06 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Mark Wielaard <mjw@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Hui Zhu <teawater@gmail.com>,
        linux-kernel@vger.kernel.org, gdb@sourceware.org,
        hellogcc@freelists.org
Subject: Re: [PATCH] Built kernel without -O2 option
Message-ID: <20101130093106.GD5203@cr0.nay.redhat.com>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
 <87r5e4lab7.fsf@basil.nowhere.org>
 <1291025536.2904.6.camel@springer.wildebeest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291025536.2904.6.camel@springer.wildebeest.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 11:12:16AM +0100, Mark Wielaard wrote:
>On Mon, 2010-11-29 at 10:59 +0100, Andi Kleen wrote:
>> Hui Zhu <teawater@gmail.com> writes:
>> 
>> > Now, there are a lot of ways to debug the Linux kernel with GDB, like
>> > qemu, kgtp or kgdb and so on.
>> > But the developer more like add a printk. It have a lot of reason, a big one is:
>> > (gdb) p ret
>> > $3 = <value optimized out>
>> > And the code execution order is not right.
>> 
>> Really the right place to fix a lot of this would be gcc (and perhaps
>> gdb). I suspect with some careful work the debugging experience
>> for -O2 could be improved a lot.
>> I also believe the latest gccs already have improvements in this area.
>
>The VTA branch was merged for GCC 4.5
>http://gcc.gnu.org/wiki/Var_Tracking_Assignments
>Which helps a lot with generating dwarf for previously "optimized out"
>values. There were also a couple of papers on generating even better
>debuginfo at the recent GCC Summit: http://gcc.gnu.org/wiki/summit2010
>
>Jakub Jelínek, Improving debug info for optimized away parameters
>http://gcc.gnu.org/wiki/summit2010?action=AttachFile&do=get&target=jelinek.pdf
>Alexandre Oliva, Consistent Views at Recommended Breakpoints
>http://gcc.gnu.org/wiki/summit2010?action=AttachFile&do=get&target=oliva.pdf
>

Cool! It would be much more convenient if this is solved by gcc.
