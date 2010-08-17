Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0HQG0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 02:26:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48947 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab0HQG0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 02:26:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OrgR5ef2OVlX653/w8H3kkEsdQmKP2f4AgLomn6Tbj7Pq5iHhgOzGmgfDB+/1rj34s
         YQ936dQmWjzR91cK/H8KVanHoLmsmIjgYj6Ise7XrLNOwMhDXqZMPy1aPQOm4xa7D4Oq
         ODpfdsvSF5OxRHewAFuz8gxYkKUSA7UgkcO4I=
MIME-Version: 1.0
In-Reply-To: <1282025491.11533.47.camel@localhost>
References: <0AE3E14D83C76F4994657326177D1FF9043D5AA91B@bgsmsx501.gar.corp.intel.com>
	<1282019933.11533.42.camel@localhost>
	<AANLkTi=1QeKuTcXAxkO4T+oGtQSSf46QNU2dxePpLu38@mail.gmail.com>
	<1282021570.11533.45.camel@localhost>
	<AANLkTi=Q=gd=LRwOKQfiXNX33DNGPrtM+1TDLSa7ed_X@mail.gmail.com>
	<1282022010.11533.46.camel@localhost>
	<AANLkTikjij74c6ba5JOjziD5MdD4j=9R9jnvGPH0Oumz@mail.gmail.com>
	<AANLkTimj+hpNqFgPMYNXcLQcLfde+iRbyX4VFansGLET@mail.gmail.com>
	<1282025491.11533.47.camel@localhost>
Date: Tue, 17 Aug 2010 14:26:19 +0800
Message-ID: <AANLkTinb_JjGZ59D76cerg-X9-NGUe6h9MOeH_v2zY7p@mail.gmail.com>
Subject: Re: FW: intel_scu_ipc
From: Zhou Peng <ailvpeng25@gmail.com>
To: Hong Liu <hong.liu@intel.com>
Cc: "Ds, Sreedhara" <sreedhara.ds@intel.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks :)

2010/8/17 Hong Liu <hong.liu@intel.com>:
> On Tue, 2010-08-17 at 13:59 +0800, Zhou Peng wrote:
>> After compile disabling intel_scu_ipc, the kernel is  vmlinuz-2.6.35+
>> In linux kernel 2.6.35 mrst.h is the same with kvm
>> (http://lxr.free-electrons.com/source/arch/x86/include/asm/mrst.h)
>
> I've checked the latest Linus linux-2.6 tree, it should be fixed.
>
>> 2010/8/17 Zhou Peng <ailvpeng25@gmail.com>:
>> > This problem seem exist in other distribution eg.
>> > http://stackoverflow.com/questions/3434676/error-while-compiling-the-linux-kernel-2-6-35
>> > http://www.spinics.net/lists/linux-wireless/msg54197.html
>> > How can the kvm to compile it if  without disabling intel_scu_ipc?.
>> >
>> > CC to KVM-ML
>> >
>> > 2010/8/17 Hong Liu <hong.liu@intel.com>:
>> >> On Tue, 2010-08-17 at 13:12 +0800, Zhou Peng wrote:
>> >>> I don't know  :)
>> >>> I get the kernel(http://www.linux-kvm.org/page/Code) by
>> >>>
>> >>> git clone git://git.kernel.org/pub/scm/virt/kvm/kvm.git
>> >>
>> >> Looks like it merged the intel_scu_ipc code while forgetting the mrst.h
>> >> change.
>> >>
>> >>>
>> >>> 2010/8/17 Hong Liu <hong.liu@intel.com>:
>> >>> > On Tue, 2010-08-17 at 12:54 +0800, Zhou Peng wrote:
>> >>> >> Hi,
>> >>> >>
>> >>> >> But MRST_CPU_CHIP_PENWELL is missing in my source. The complete file is below.
>> >>> >
>> >>> > So... which kernel are you using for compile?
>> >>> >
>> >>> > Thanks,
>> >>> > Hong
>> >>> >
>> >>> >>
>> >>> >> -------
>> >>> >> kvm$ find -name mrst.h
>> >>> >> ./include/config/x86/mrst.h
>> >>> >> ./arch/x86/include/asm/mrst.h
>> >>> >> kvm$ vim arch/x86/include/asm/mrst.h
>> >>> >> kvm$ vim include/config/x86/mrst.h
>> >>> >> kvm$ cat include/config/x86/mrst.h
>> >>> >> kvm$ cat arch/x86/include/asm/mrst.h
>> >>> >> /*
>> >>> >>  * mrst.h: Intel Moorestown platform specific setup code
>> >>> >>  *
>> >>> >>  * (C) Copyright 2009 Intel Corporation
>> >>> >>  *
>> >>> >>  * This program is free software; you can redistribute it and/or
>> >>> >>  * modify it under the terms of the GNU General Public License
>> >>> >>  * as published by the Free Software Foundation; version 2
>> >>> >>  * of the License.
>> >>> >>  */
>> >>> >> #ifndef _ASM_X86_MRST_H
>> >>> >> #define _ASM_X86_MRST_H
>> >>> >> extern int pci_mrst_init(void);
>> >>> >> int __init sfi_parse_mrtc(struct sfi_table_header *table);
>> >>> >>
>> >>> >> #define SFI_MTMR_MAX_NUM 8
>> >>> >> #define SFI_MRTC_MAX  8
>> >>> >>
>> >>> >> #endif /* _ASM_X86_MRST_H */
>> >>> >>
>> >>> >>
>> >>> >> Thanks,
>> >>> >>
>> >>> >> 2010/8/17 Hong Liu <hong.liu@intel.com>:
>> >>> >> > On Tue, 2010-08-17 at 11:38 +0800, Ds, Sreedhara wrote:
>> >>> >> >>
>> >>> >> >> -----Original Message-----
>> >>> >> >> From: Zhou Peng [mailto:ailvpeng25@gmail.com]
>> >>> >> >> Sent: Tuesday, August 17, 2010 8:26 AM
>> >>> >> >> To: Ds, Sreedhara
>> >>> >> >> Subject: intel_scu_ipc
>> >>> >> >>
>> >>> >> >> Hi Sreedhara DS,
>> >>> >> >>
>> >>> >> >> Where does "MRST_CPU_CHIP_PENWELL " be defined please?
>> >>> >> >
>> >>> >> > It is defined in asm/mrst.h, please check the
>> >>> >> > arch/x86/include/asm/mrst.h file, seems there is problem with the
>> >>> >> > sfi_table_header structure which defined in include/linux/sfi.h.
>> >>> >> >
>> >>> >> > Thanks,
>> >>> >> > Hong
>> >>> >> >
>> >>> >> >>
>> >>> >> >> While compiling the kvm linux kernel on my ubuntu 10.04(Linux
>> >>> >> >> xxxx-laptop 2.6.32-24-generic #39-Ubuntu SMP Wed Jul 28 06:07:29 UTC
>> >>> >> >> 2010 i686 GNU/Linux), the  err below appear, How to figure out please?
>> >>> >> >>
>> >>> >> >> =err msg=
>> >>> >> >> drivers/platform/x86/intel_scu_ipc.c: In function 'pwr_reg_rdwr':
>> >>> >> >> drivers/platform/x86/intel_scu_ipc.c:175: error:
>> >>> >> >> 'MRST_CPU_CHIP_PENWELL' undeclared (first use in this function)
>> >>> >> >> drivers/platform/x86/intel_scu_ipc.c:175: error: (Each undeclared
>> >>> >> >> identifier is rep
>> >>> >> >> orted only once
>> >>> >> >> drivers/platform/x86/intel_scu_ipc.c:175: error: for each function it
>> >>> >> >> appears in.)
>> >>> >> >> drivers/platform/x86/intel_scu_ipc.c: In function
>> >>> >> >> 'intel_scu_ipc_init':
>> >>> >> >> drivers/platform/x86/intel_scu_ipc.c:741: error: implicit declaration
>> >>> >> >> of function '
>> >>> >> >> mrst_identify_cpu'
>> >>> >> >> make[3]: *** [drivers/platform/x86/intel_scu_ipc.o] Error 1
>> >>> >> >> make[2]: *** [drivers/platform/x86] Error 2
>> >>> >> >> make[1]: *** [drivers/platform] Error 2
>> >>> >> >> make: *** [drivers] Error 2
>> >>> >> >>
>> >>> >> >>
>> >>> >> >> =search the kvm kernel tree=
>> >>> >> >> kvm$ grep MRST_CPU_CHIP_PENWELL . -R
>> >>> >> >> ./drivers/platform/x86/intel_scu_ipc.c:    if (platform
>> >>> >> >> !=MRST_CPU_CHIP_PENWELL) {
>> >>> >> >> ./drivers/platform/x86/intel_scu_ipc.c:        if (platform
>> >>> >> >> !=MRST_CPU_CHIP_PENWELL) {
>> >>> >> >>
>> >>> >> >> Thanks,
>> >>> >> >>
>> >>> >> >> Best,
>> >>> >> >
>> >>> >> >
>> >>> >> >
>> >>> >>
>> >>> >>
>> >>> >>
>> >>> >
>> >>> >
>> >>> >
>> >>>
>> >>>
>> >>>
>> >>
>> >>
>> >>
>> >
>> >
>> >
>> > --
>> > Zhou Peng
>> >
>>
>>
>>
>
>
>



-- 
Zhou Peng
