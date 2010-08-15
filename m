Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab0HOQC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 12:02:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163Ab0HOQC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 12:02:58 -0400
Message-ID: <4C67D8A3.1080405@redhat.com>
Date: Sun, 15 Aug 2010 15:08:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Anjali Kulkarni <anjali@juniper.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Freebsd image from Qemu hangs on booting in KVM
References: <C8807265.2600D%anjali@juniper.net>
In-Reply-To: <C8807265.2600D%anjali@juniper.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/05/2010 11:51 PM, Anjali Kulkarni wrote:
> Thanks Avi,
> I am trying to reproduce this on another setup, and do not see the issue.
> My understanding is to run KVM + Qemu, I only need to install KVM modules,
> and Qemu does not need to be modified. Is that correct?
> I see
>
> [root@ipg-virt01 anjali]# lsmod | grep kvm
> kvm_intel              87016  0
> kvm                   211496  1 kvm_intel
>
> [root@ipg-virt01 anjali]# modprobe -l 'kvm*'
> /lib/modules/2.6.18-164.el5/kernel/extra/kvm.ko
> /lib/modules/2.6.18-164.el5/kernel/extra/kvm-amd.ko
> /lib/modules/2.6.18-164.el5/kernel/extra/kvm-intel.ko
>
> And then I run Qemu, as I did, before installing KVM. It should just use
> KVM? Is there any way I can check?

'info kvm' from the monitor

> Btw, when it hangs, I cannot even press any key, so not sure how I can get
> those commands you suggest below..

alt-ctrl-2

-- 
error compiling committee.c: too many arguments to function

