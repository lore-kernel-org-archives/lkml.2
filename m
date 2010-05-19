Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0ESRJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:09:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab0ESRJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:09:39 -0400
Message-ID: <4BF41B4A.1000107@redhat.com>
Date: Wed, 19 May 2010 20:09:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Harald Dunkel <harald.dunkel@aixigo.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: kvm: network problem with Solaris 10u8 guest
References: <4BF3EBA8.5040808@aixigo.de>
In-Reply-To: <4BF3EBA8.5040808@aixigo.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 04:46 PM, Harald Dunkel wrote:
> Hi folks,
>
>    

Please post kvm issues to the kvm mailing list.

> I am trying to run Solaris 10u8 as a guest in kvm (kernel
> 2.6.33.2). Problem: The virtual network devices don't work
> with this Solaris version.
>
> e1000 and pcnet work just by chance, as it seems. I can ping
> the guest (even though some packets are lost). I cannot use
> ssh to login.
>
> rtl8139 and ne2k_pci are not even listed by "ifconfig -a" on
> the guest.
>
> Solaris 10u6 worked fine (using the e1000 emulation). Same for
> the Linux guests.
>
> Can anybody reproduce this problem?
>
>
> Any helpful comment would be highly appreciated. Of course
> I would be glad to help to track this down.
>    

Does opensolaris exhibit the the same problems?  If so, you can probably 
bisect the driver to find the change that broke the device.  With that 
we can probably deduce if it is the device or driver that is broken, and 
what the issue is.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

