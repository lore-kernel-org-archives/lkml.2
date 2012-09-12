Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761099Ab2ILSL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:11:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57497 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761083Ab2ILSLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:11:25 -0400
Message-ID: <5050D048.4010704@suse.cz>
Date: Wed, 12 Sep 2012 20:11:20 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Jiri Slaby <jirislaby@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: qemu-kvm loops after kernel udpate
References: <504F7ED8.1030702@suse.cz> <20120911190303.GA3626@amt.cnet> <504F93F1.2060005@suse.cz> <50504299.2050205@redhat.com> <50504439.3050700@suse.cz> <5050453B.6040702@redhat.com>
In-Reply-To: <5050453B.6040702@redhat.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 10:18 AM, Avi Kivity wrote:
> On 09/12/2012 11:13 AM, Jiri Slaby wrote:
>>
>>>  Please provide the output of vmxcap
>>> (http://goo.gl/c5lUO),
>>
>>   Unrestricted guest                       no
> 
> The big real mode fixes.
> 
> 
>>
>>> and a snapshot of kvm_stat while the guest is hung.
>>
>> kvm statistics
>>
>>  exits                                      6778198  615942
>>  host_state_reload                             1988     187
>>  irq_exits                                     1523     138
>>  mmu_cache_miss                                   4       0
>>  fpu_reload                                       1       0
> 
> Please run this as root so we get the tracepoint based output; and press
> 'x' when it's running so we get more detailed output.

kvm statistics

 kvm_exit                                  13798699  330708
 kvm_entry                                 13799110  330708
 kvm_page_fault                            13793650  330604
 kvm_exit(EXCEPTION_NMI)                    6188458  330604
 kvm_exit(EXTERNAL_INTERRUPT)                  2169     105
 kvm_exit(TPR_BELOW_THRESHOLD)                   82       0
 kvm_exit(IO_INSTRUCTION)                         6       0
 kvm_exit(PAUSE_INSTRUCTION)                      5       0
 kvm_exit(MCE_DURING_VMENTRY)                     5       0
 kvm_exit(DR_ACCESS)                              5       0
 kvm_exit(VMPTRLD)                                5       0
 kvm_exit(VMLAUNCH)                               5       0
 kvm_exit(INVLPG)                                 5       0
 kvm_exit(VMCALL)                                 5       0
 kvm_exit(WBINVD)                                 5       0
 kvm_exit(MONITOR_INSTRUCTION)                    5       0
 kvm_exit(MWAIT_INSTRUCTION)                      4       0
 kvm_exit(NMI_WINDOW)                             4       0
 kvm_exit(VMREAD)                                 4       0
 kvm_exit(XSETBV)                                 4       0
 kvm_exit(RDPMC)                                  4       0
 kvm_exit(CPUID)                                  4       0
 kvm_exit(VMCLEAR)                                4       0
 kvm_exit(PENDING_INTERRUPT)                      4       0
 kvm_exit(VMRESUME)                               4       0
 kvm_exit(APIC_ACCESS)                            4       0
 kvm_exit(INVALID_STATE)                          4       0
 kvm_exit(MSR_READ)                               4       0
 kvm_exit(VMOFF)                                  4       0
 kvm_exit(RDTSC)                                  4       0
 kvm_exit(MSR_WRITE)                              4       0
 kvm_exit(VMPTRST)                                4       0
 kvm_exit(VMWRITE)                                4       0
 kvm_exit(HLT)                                    3       0
 kvm_exit(EPT_VIOLATION)                          3       0
 kvm_exit(TASK_SWITCH)                            3       0
 kvm_exit(CR_ACCESS)                              3       0
 kvm_exit(TRIPLE_FAULT)                           3       0
 kvm_exit(VMON)                                   3       0
 kvm_exit(EPT_MISCONFIG)                          3       0

thanks,
-- 
js
suse labs
