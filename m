Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab0EZS3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:29:21 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65020 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571Ab0EZS3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:29:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=hQgKKNo6gm2w4DSYghPGS3rkCt5oUw1t9OzCJbOwl019j0NFfZ4DmNpZgF5vyalxJR
         5bIfmWWN0heuKfp+3cqutKtnw/fAhb/m6p7Gt1g88zcDdCyYGVDmt7URNseVbe9AVOSg
         MgoKA1QSeJv4sq+Hx2fV0HpACQXbMAwgrTON8=
MIME-Version: 1.0
In-Reply-To: <4BFCB9ED.9090806@gmail.com>
References: <AANLkTilqascTmKEr_aFu2QxqabXaz7z2UXAQNV7HA6sT@mail.gmail.com>
	<AANLkTikBJ31DBSqGmLDxpYFHY_DTKKrZnFbPVVlD_6YV@mail.gmail.com>
	<4BFCB9ED.9090806@gmail.com>
Date: Wed, 26 May 2010 12:29:18 -0600
Message-ID: <AANLkTilNP1ymRBUpLJLfGpm2k46zMm4_XqcpAs1xsSqf@mail.gmail.com>
Subject: Re: [ANNOUNCE] ndiswrapper-2.6.34
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am on it.  Thanks.  The 1.56 version seems OK except with older
laptops.  I'll work on this one this evening.

Jeff

On Wed, May 26, 2010 at 12:04 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 05/25/2010 10:43 PM, Jeffrey Merkey wrote:
>>
>> NOTE:  Porting the 1.56 version too - its also fucking broken with
>> iwconfig and wireless extensions.  I'll post the shit on google code
>> since the native wireless drivers in linux dont work on windows
>> laptops and probably never will without massive firmware theft.  At
>> any rate the 1.54 version works on 2.6.34
>>
>> Jeff
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
>
>
> yeah it's n=broken again with the laest HEAD:
>
> make
> make -C driver
> make[1]: Entering directory `/home/test/ndiswrapper-1.54-2.6.28/driver'
> make -C /lib/modules/2.6.34-07725-gbedd0eb/build
> M=/home/test/ndiswrapper-1.54-2.6.28/driver
> make[2]: Entering directory `/home/kernel/2.6.34'
>  LD      /home/test/ndiswrapper-1.54-2.6.28/driver/built-in.o
>  MKEXPORT /home/test/ndiswrapper-1.54-2.6.28/driver/crt_exports.h
>  MKEXPORT /home/test/ndiswrapper-1.54-2.6.28/driver/hal_exports.h
>  MKEXPORT /home/test/ndiswrapper-1.54-2.6.28/driver/ndis_exports.h
>  MKEXPORT /home/test/ndiswrapper-1.54-2.6.28/driver/ntoskernel_exports.h
>  MKEXPORT /home/test/ndiswrapper-1.54-2.6.28/driver/ntoskernel_io_exports.h
>  MKEXPORT /home/test/ndiswrapper-1.54-2.6.28/driver/rtl_exports.h
>  MKEXPORT /home/test/ndiswrapper-1.54-2.6.28/driver/usb_exports.h
>  MKSTUBS /home/test/ndiswrapper-1.54-2.6.28/driver/win2lin_stubs.h
>  CC [M]  /home/test/ndiswrapper-1.54-2.6.28/driver/crt.o
>  CC [M]  /home/test/ndiswrapper-1.54-2.6.28/driver/hal.o
>  CC [M]  /home/test/ndiswrapper-1.54-2.6.28/driver/iw_ndis.o
>  CC [M]  /home/test/ndiswrapper-1.54-2.6.28/driver/loader.o
>  CC [M]  /home/test/ndiswrapper-1.54-2.6.28/driver/ndis.o
>  CC [M]  /home/test/ndiswrapper-1.54-2.6.28/driver/ntoskernel.o
>  CC [M]  /home/test/ndiswrapper-1.54-2.6.28/driver/ntoskernel_io.o
> /home/test/ndiswrapper-1.54-2.6.28/driver/ntoskernel_io.c: In function
> 'IoConnectInterrupt':
> /home/test/ndiswrapper-1.54-2.6.28/driver/ntoskernel_io.c:566: warning:
> passing argument 2 of 'request_irq' from incompatible pointer type
> include/linux/interrupt.h:130: note: expected 'irq_handler_t' but argument
> is of type 'void (*)(int,  void *)'
>  CC [M]  /home/test/ndiswrapper-1.54-2.6.28/driver/pe_linker.o
>  CC [M]  /home/test/ndiswrapper-1.54-2.6.28/driver/pnp.o
>  CC [M]  /home/test/ndiswrapper-1.54-2.6.28/driver/proc.o
>  CC [M]  /home/test/ndiswrapper-1.54-2.6.28/driver/rtl.o
>  CC [M]  /home/test/ndiswrapper-1.54-2.6.28/driver/wrapmem.o
>  CC [M]  /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.o
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c: In function
> 'set_multicast_list':
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:927: error: 'struct
> net_device' has no member named 'mc_count'
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:930: error: 'struct
> net_device' has no member named 'mc_count'
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:934: error: 'struct
> net_device' has no member named 'mc_count'
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:934: warning: type
> defaults to 'int' in declaration of '_min2'
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:934: error: 'struct
> net_device' has no member named 'mc_count'
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:941: error: 'struct
> net_device' has no member named 'mc_list'
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:942: error:
> dereferencing pointer to incomplete type
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:943: error:
> dereferencing pointer to incomplete type
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:945: error:
> dereferencing pointer to incomplete type
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c: In function
> 'notifier_event':
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:1693: error: 'struct
> net_device' has no member named 'open'
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c: In function
> 'ndis_start_device':
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:1749: error: 'struct
> net_device' has no member named 'open'
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:1750: error: 'struct
> net_device' has no member named 'hard_start_xmit'
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:1751: error: 'struct
> net_device' has no member named 'stop'
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:1752: error: 'struct
> net_device' has no member named 'get_stats'
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:1753: error: 'struct
> net_device' has no member named 'change_mtu'
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:1754: error: 'struct
> net_device' has no member named 'do_ioctl'
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:1758: error: 'struct
> net_device' has no member named 'set_multicast_list'
> /home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.c:1759: error: 'struct
> net_device' has no member named 'set_mac_address'
> make[3]: *** [/home/test/ndiswrapper-1.54-2.6.28/driver/wrapndis.o] Error 1
> make[2]: *** [_module_/home/test/ndiswrapper-1.54-2.6.28/driver] Error 2
> make[2]: Leaving directory `/home/kernel/2.6.34'
> make[1]: *** [modules] Error 2
> make[1]: Leaving directory `/home/test/ndiswrapper-1.54-2.6.28/driver'
> make: *** [all] Error 2
>
>
> which is:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=22bedad3ce112d5ca1eaf043d4990fa2ed698c87;hp=a748ee2426817a95b1f03012d8f339c45c722ae1
>
> Justin P. Mattock
>
