Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121Ab2KWJfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:35:18 -0500
Received: from mx2.parallels.com ([64.131.90.16]:45335 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759105Ab2KWJfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:35:09 -0500
Message-ID: <50AF4343.6070002@parallels.com>
Date: Fri, 23 Nov 2012 13:34:59 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: azurIt <azurit@pobox.sk>
CC: Michal Hocko <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, cgroups mailinglist <cgroups@vger.kernel.org>
Subject: Re: memory-cgroup bug
References: <20121121200207.01068046@pobox.sk>, <20121122152441.GA9609@dhcp22.suse.cz>, <20121122190526.390C7A28@pobox.sk>, <20121122214249.GA20319@dhcp22.suse.cz>, <20121122233434.3D5E35E6@pobox.sk> <20121123074023.GA24698@dhcp22.suse.cz> <20121123102137.10D6D653@pobox.sk>
In-Reply-To: <20121123102137.10D6D653@pobox.sk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 01:21 PM, azurIt wrote:
>> Either use gdb YOUR_VMLINUX and disassemble mem_cgroup_handle_oom or
>> use objdump -d YOUR_VMLINUX and copy out only mem_cgroup_handle_oom
>> function.
> If 'YOUR_VMLINUX' is supposed to be my kernel image:
> 
> # gdb vmlinuz-3.2.34-grsec-1 

this is vmlinuz, not vmlinux. This is the compressed image.

> 
> # file vmlinuz-3.2.34-grsec-1 
> vmlinuz-3.2.34-grsec-1: Linux kernel x86 boot executable bzImage, version 3.2.34-grsec (root@server01) #1, RO-rootFS, swap_dev 0x3, Normal VGA
> 
> I'm probably doing something wrong :)

You need this:

[glauber@straightjacket linux-glommer]$ file vmlinux
vmlinux: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically
linked, BuildID[sha1]=0xba936ee6b6096f9bc4c663f2a2ee0c2d2481c408, not
stripped

instead of bzImage.

