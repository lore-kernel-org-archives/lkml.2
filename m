Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0ESTkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:40:05 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:41118 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab0ESTkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:40:01 -0400
Message-ID: <4BF43E8F.8040902@msgid.tls.msk.ru>
Date: Wed, 19 May 2010 23:39:59 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Harald Dunkel <harald.dunkel@aixigo.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: kvm: network problem with Solaris 10u8 guest
References: <4BF3EBA8.5040808@aixigo.de> <4BF41B4A.1000107@redhat.com>
In-Reply-To: <4BF41B4A.1000107@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

19.05.2010 21:09, Avi Kivity wrote:
> On 05/19/2010 04:46 PM, Harald Dunkel wrote:
>> I am trying to run Solaris 10u8 as a guest in kvm (kernel
>> 2.6.33.2). Problem: The virtual network devices don't work
>> with this Solaris version.
>>
>> e1000 and pcnet work just by chance, as it seems. I can ping
>> the guest (even though some packets are lost). I cannot use
>> ssh to login.
>>
>> rtl8139 and ne2k_pci are not even listed by "ifconfig -a" on
>> the guest.
>>
>> Solaris 10u6 worked fine (using the e1000 emulation). Same for
>> the Linux guests.
>>
> Does opensolaris exhibit the the same problems? If so, you can probably
> bisect the driver to find the change that broke the device. With that we
> can probably deduce if it is the device or driver that is broken, and
> what the issue is.

I verified this right after Harald posted his original
bugreport against debian qemu-kvm package (*).  No,
opensolaris does NOT shows this bug.

I even tried solaris install image -- sol-10-u8-ga-x86-dvd.iso,
but it works here as far as I can see.  I performed only basic
tests however, -- basically because I just don't remember how
to _use_ solaris (it's been about 10 years ago), and can only
do some telnet/ping/ftp.

(*) http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=579751

/mjt
