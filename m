Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab2FCN7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 09:59:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62374 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2FCN7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 09:59:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAO6yerKkadsg5-9hPzZHVhk_Msoym=JpVTHqDpbfPNJsiP8nzg@mail.gmail.com>
References: <CABexPfEq7cz-nng-gz9TQB=9pyeBFALsRDAPSDbM4HFe=cjxJA@mail.gmail.com>
	<CABexPfGqW-4hTrsPE=dNUsQ84kikr2sAZ=HKckk6sbFbz6quaQ@mail.gmail.com>
	<CAO6yerKkadsg5-9hPzZHVhk_Msoym=JpVTHqDpbfPNJsiP8nzg@mail.gmail.com>
Date: Sun, 3 Jun 2012 21:59:14 +0800
Message-ID: <CABexPfHnpZDHhcvum6bUy=vcqNvfxEY9bWAzAPm-j_p0tm2BFw@mail.gmail.com>
Subject: Re: [build error] building failed with sample kernel code enabled
From: Zhihua Che <zhihua.che@gmail.com>
To: bing deng <deng8bing@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/3 bing deng <deng8bing@gmail.com>:
>
>
> On Sun, Jun 3, 2012 at 7:23 PM, Zhihua Che <zhihua.che@gmail.com> wrote:
>>
>> 2012/6/3 Zhihua Che <zhihua.che@gmail.com>:
>> > Hi,
>> >
>> >    I was building kernel 3.4 with kernel sample code enabled on my
>> > ubuntu-11.10.
>> >    The steps I followed are:
>> >    make O=xxx menuconfig
>> >    make O=xxx -j16
>> >    But it failed and complaint the following:
>> >
>> > linux/samples/seccomp/bpf-fancy.c:13:27: fatal error: linux/seccomp.h:
>> > No such file or
>> >
>> > directory/home/harvey/open-projects/linux/samples/seccomp/bpf-direct.c:21:27:
>> > fatal error: linux/seccomp.h: No such file or directory
>> > compilation terminated.
>>
>>
>> I forgot it.  I've checked the existence of seccomp.h. it's in the source
>> tree.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
> Are the header linux/seccomp.h or directory included in the make file?
>
> Best Regards,
> Bing


I find the LINUXINCLUDE variable in MAKEFILE, it contains the
directory  path 'include' where the linux/seccomp.h is.
So I guess it's included in the searching path.
