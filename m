Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2GTW7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 18:59:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40964 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2GTW7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 18:59:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120720210606.GC15677@oc1711230544.ibm.com>
References: <CADdae-i2FWspdm_BPQAeO3HUUyOWj8rDui0cTGR6fkRv7yr2zw@mail.gmail.com>
	<20120720132153.GA26110@redhat.com>
	<20120720202155.GB15677@oc1711230544.ibm.com>
	<CADdae-hyq7RALEg6fOTQZc_cDoi8PnovBZ2xNdsZRNTqfJnORA@mail.gmail.com>
	<20120720210606.GC15677@oc1711230544.ibm.com>
Date: Sat, 21 Jul 2012 00:59:12 +0200
X-Google-Sender-Auth: WtON5Cf-fWLtibK9nO0XU35WCBg
Message-ID: <CADdae-iQAoA_n3_azKWOR7HAe9_tOWybN_bGVG-C_P3Pa8Y1WA@mail.gmail.com>
Subject: Re: oops in kernel ( 3.4.x -> 3.5rc )
From: nicolas prochazka <prochazka.nicolas@gmail.com>
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well done
1fd36adcd98c14d2fd97f545293c488775cb2823  :  the bug occurs   ( cf dump )
1dce27c5aa6770e9d195f2bb7db1db3d4dde5591 :  the bug not occurs

Regards,
Nicolas Prochazka.

dump  / 1fd36adcd98c14d2fd97f545293c488775cb2823
lloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
VMtap: no IPv6 routers present
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 71 not NULL!
alloc_fd: slot 121 not NULL!
alloc_fd: slot 96 not NULL!
alloc_fd: slot 100 not NULL!
alloc_fd: slot 110 not NULL!
alloc_fd: slot 121 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
brE: no IPv6 routers present
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 121 not NULL!
alloc_fd: slot 142 not NULL!
alloc_fd: slot 153 not NULL!
alloc_fd: slot 153 not NULL!
alloc_fd: slot 153 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 70 not NULL!
alloc_fd: slot 100 not NULL!
alloc_fd: slot 102 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 106 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 100 not NULL!
alloc_fd: slot 100 not NULL!
alloc_fd: slot 100 not NULL!
alloc_fd: slot 100 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 106 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 100 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 36 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 100 not NULL!
alloc_fd: slot 100 not NULL!
alloc_fd: slot 100 not NULL!
alloc_fd: slot 100 not NULL!
alloc_fd: slot 100 not NULL!
alloc_fd: slot 100 not NULL!
alloc_fd: slot 100 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 100 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 68 not NULL!
alloc_fd: slot 100 not NULL!
alloc_fd: slot 100 not NULL!
------------[ cut here ]------------
kernel BUG at fs/open.c:873!
invalid opcode: 0000 [#1] SMP
CPU 0
Modules linked in: kvm_intel kvm

then BUG paging request as usual


2012/7/20 Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>:
> On Fri, Jul 20, 2012 at 10:52:40PM +0200, nicolas prochazka wrote:
>> Hello
>> the problem is occured with  :
>> - linux kernel 3.4.5    i do not test with 3.4.0 / 1 / 2 / 3 / 4    ,
>> but i can if you want
>> - linux kernel 3.5rc6 rc7  / do not test with other rc.
>>
>> the problem is not occured with :
>> linux kernel 3.3.4 / 3.3.8
>>
>> These servers are used for :
>> - starting a lot of virtual machine with qemu-kvm ( ~ 40 )   ( lot of
>> select i think)
>> - do a lot of network tests with openvswitch
>>
>> I can test a kernel 3.4.x before and after a commit id (?) to find a regression.
>>
>> Regards,
>> Nicolas.
>>
>
> Can you try this commit 1fd36adcd98c14d2fd97f545293c488775cb2823? And
> the commit before it?
>
>>
>> 2012/7/20 Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>:
>> > On Fri, Jul 20, 2012 at 09:21:53AM -0400, Dave Jones wrote:
>> >> On Fri, Jul 20, 2012 at 11:56:06AM +0200, nicolas prochazka wrote:
>> >>
>> >>  > [ 2384.900061] BUG: unable to handle kernel paging request at 000000010000002f
>> >>
>> >> That '1' looks like a random bit flip. Try running memtest86.
>> >>
>> >
>> > Looks more a 32-bit value of 1 followed by a 32-bit value of 0x2f. Most
>> > likely a pointer to some other piece of a struct. However, taking a look
>> > at fs/files.c code, nothing seems suspicious.
>> >
>> > Nicolas, it wasn't clear to me if you had problems with 3.4 too. There
>> > has been some changes in fs/files.c on 3.4-rc1 in the piece of code
>> > where you hit the problem.
>> >
>> > What does your system exercise? Any chance you are using a lot of
>> > select, which has also been changed in those same patches to fs/files.c?
>> >
>> > Regards.
>> > Cascardo.
>> >
>> >
>> >>  > [ 2384.910010] Pid: 23838, comm: queue.sh Tainted: G      D W
>> >>
>> >> This wasn't the first problem either.
>> >>
>> >>  > [ 2397.885344] BUG: unable to handle kernel paging request at 000000010000003b
>> >>
>> >> Looks like the same flipped bit.
>> >>
>> >>       Dave
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> Please read the FAQ at  http://www.tux.org/lkml/
>> >>
>> >
>>
>
