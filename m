Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab1LZOSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 09:18:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab1LZOSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 09:18:30 -0500
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=windows-1252
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20111225110109.GA28757@alea.gnuu.de>
Date: Mon, 26 Dec 2011 15:18:14 +0100
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <68FBAE93-2F91-43F9-AAE2-75A934588DD5@suse.de>
References: <20111107194838.GA23558@alea.gnuu.de> <20111220202711.GD6830@alea.gnuu.de> <C3B4A5C9-0AE0-49C8-A349-879ADDA01804@suse.de> <20111224103108.GA19586@alea.gnuu.de> <20111224111359.GB3938@alea.gnuu.de> <C40CA3A1-2397-423B-96B3-CBEE4EA7EA30@suse.de> <20111225110109.GA28757@alea.gnuu.de>
To: =?iso-8859-1?Q?J=F6rg_Sommer?= <joerg@alea.gnuu.de>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25.12.2011, at 12:01, Jörg Sommer wrote:

> Alexander Graf hat am Sat 24. Dec, 18:05 (+0100) geschrieben:
>> On 24.12.2011, at 12:13, Jörg Sommer wrote:
>>> Jörg Sommer hat am Sat 24. Dec, 11:31 (+0100) geschrieben:
>>>> Alexander Graf hat am Fri 23. Dec, 14:50 (+0100) geschrieben:
>>>>> On 20.12.2011, at 21:27, Jörg Sommer wrote:
>>>>>> 
>>>>>> I'm so sorry to have to report a new bug in one of your patches. It was
>>>>>> covered by the one above. I've picked the commit for it from your git
>>>>>> repository and now, the kernel build fails with this error:
>>>>>> 
>>>>>> BOOTCC  arch/powerpc/boot/fdt_strerror.o
>>>>>> BOOTAR  arch/powerpc/boot/wrapper.a
>>>>>> WRAP    arch/powerpc/boot/zImage.pmac
>>>>>> WRAP    arch/powerpc/boot/zImage.coff
>>>>>> ERROR: "kvmppc_h_pr" [arch/powerpc/kvm/kvm.ko] undefined!
>>>>>> make[3]: *** [__modpost] Fehler 1
>>>>>> make[2]: *** [modules] Fehler 2
>>>>>> make[2]: *** Warte auf noch nicht beendete Prozesse...
>>>>>> WRAP    arch/powerpc/boot/zImage.miboot
>>>>>> make[1]: *** [deb-pkg] Fehler 2
>>>>>> make: *** [deb-pkg] Fehler 2
> 
>> I was actually thinking of:
>> 
>> commit dfc209648daf8ba4197e71376b76c95fd26fd272
>> Author: Andreas Schwab <schwab@linux-m68k.org>
>> Date:   Tue Nov 8 07:17:39 2011 +0000
> 
>> But yes :). I guess we need to make sure this commit also lands in 3.2 :(.
> 
> So there are at least two commits they must go into 3.2 to make the
> kernel build again, from my point of view:
> 
> • KVM: PPC: protect use of kvmppc_h_pr
> • KVM: PPC: move compute_tlbie_rb to book3s_64 common header

Yup, thanks :). All compile fixes that piled up in my tree are now with Avi to push to 3.2 :).


Alex

