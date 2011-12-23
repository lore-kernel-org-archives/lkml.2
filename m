Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab1LWGWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 01:22:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44007 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1LWGWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 01:22:15 -0500
MIME-Version: 1.0
In-Reply-To: <CABiHV1ROEiCD-dMER+MTPQKgKTgEj2_ynCJ3XOd_YwPA-xQySQ@mail.gmail.com>
References: <CANFwon3hXH-1PQi1XZsxjFFDQ4Z0X25db87rJYG_4DF2ZXGLeQ@mail.gmail.com>
 <CABiHV1ROEiCD-dMER+MTPQKgKTgEj2_ynCJ3XOd_YwPA-xQySQ@mail.gmail.com>
From: Hui Zhu <teawater@gmail.com>
Date: Fri, 23 Dec 2011 14:21:32 +0800
Message-ID: <CANFwon1XmtFZbUimF7kGSoz=ASyoZ64f-k8s8cO=0fwTcc-N7w@mail.gmail.com>
Subject: Re: KGTP (Linux Kernel debugger and tracer) 20111218 release
To: Geunsik Lim <leemgs1@gmail.com>
Cc: linux-kernel@vger.kernel.org, "gdb@sourceware.org" <gdb@sourceware.org>,
        kgtp <kgtp@freelists.org>, Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geunsik,

On Fri, Dec 23, 2011 at 12:58, Geunsik Lim <leemgs1@gmail.com> wrote:
> On Sun, Dec 18, 2011 at 9:11 PM, Hui Zhu <teawater@gmail.com> wrote:
>> KGTP is a realtime and lightweight Linux Kernel debugger and tracer.
>>
>> It makes Linux Kernel supply a GDB remote debug interface. Then GDB in
>> current machine or remote machine (see
>> https://code.google.com/p/kgtp/wiki/HOWTO#Make_GDB_connect_to_gtp) can
>> debug and trace Linux through GDB tracepoint without stopping the
>> Linux Kernel.
>> And even if the board doesn't have GDB on it and doesn't have
>> interface for remote debug. It can debug the Linux Kernel using
>> offline debug (See
>> https://code.google.com/p/kgtp/wiki/HOWTO#Offline_debug).
>> And it can work with Android (See
>> https://code.google.com/p/kgtp/wiki/HowToUseKGTPinAndroid).
>> Now, it supports X86-32, X86-64, MIPS and ARM.
>>
>> Now, KGTP 20111218 release.
>> You can get the package for it from
>> http://kgtp.googlecode.com/files/kgtp_20111218.tar.bz2
>> or
>> svn co https://kgtp.googlecode.com/svn/tags/20111218
>>
>> The change of this release is:
>> Add gtp_rb to be the new frame buffer to make trace record speed up
>> and more friendly to the older version Linux kernel.
>> Rename gtp.patch to gtp_for_review.patch.
>> Add Linux Kernel patch gtp_3.0_to_upstream.patch(3.0 to upstream),
>> gtp_2.6.39.patch(2.6.39), gtp_2.6.33_to_2.6.38.patch(2.6.33 to 2.6.38)
>> and gtp_older_to_2.6.32.patch(older to 2.6.32).
> Thank you for your upgrade work for the compatibility among various
> linux version.
> I am testing normally on evaluation board based on ARM cortex using
> the latest Linux.

Thanks.  Please tell me if you get some trouble with it.

>> Then you can include KGTP in your Kernel source tree.
>> Add special trace state variable $gtp_version to show the version of KGTP.
>> Fix some build errors of gtp_for_review.patch.
>> Fix some build errors in ARM.
>> Update doc.
>> To get other change info please goto https://code.google.com/p/kgtp/wiki/UPDATE
>>
>> According to the comments of Christoph.  I make a patch for Linux
>> Kernel and make it looks OK with checkpatch.pl.  The file
>> gtp_for_review.patch is include in the source of KGTP code.
> I have one question about KGTP.
> Previously, GDB Tracepoints for linux Linux kernel 2.6.19 is developed
> by Jim Blandy
> of Cygnus. He also presented to share this practical approach at FOSDEM 2007.
> If you can, Can you explain the difference(e.g: merits, demerits, and
> so on) between
> GDB Tracepoint of Jim  and KGTP by you?

I am not sure about this one.  Because I cannot find anything about
it.  Could you give me a link or something?

For now, I just know the difference is I am a GDB developer too.  So I
can make KGTP develop more close to GDB devekop.  It can handle some
issue more easy.

Thanks,
Hui

>
>>
>> Thanks,
>> Hui
>
>
>
> --
> Best regards,
> Geunsik Lim ( Samsung Electronics )
> Blog : http://blog.naver.com/invain/
> Homepage: http://leemgs.fedorapeople.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
