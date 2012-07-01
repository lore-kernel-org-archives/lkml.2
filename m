Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab2GAJlx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 05:41:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab2GAJlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 05:41:51 -0400
Message-ID: <4FF01B59.1010600@redhat.com>
Date: Sun, 01 Jul 2012 12:41:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>, "Michael S. Tsirkin" <mst@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: Tree for June 29 (kvm)
References: <20120629175341.22a9eccd30d9c085bfd92c1d@canb.auug.org.au> <4FEDEE6A.7020608@xenotime.net>
In-Reply-To: <4FEDEE6A.7020608@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 09:05 PM, Randy Dunlap wrote:
> On 06/29/2012 12:53 AM, Stephen Rothwell wrote:
> 
>> Hi all,
>> 
>> Changes since 20120628:
> 
> 
> 
> on i386:
> 
> arch/x86/built-in.o: In function `kvm_guest_apic_eoi_write':
> kvm.c:(.text+0x3561f): undefined reference to `apic'
> 
> 
> Full randconfig file is attached.

Michael, please disable pveoi if built with no apic.


-- 
error compiling committee.c: too many arguments to function


