Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab1BXKRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 05:17:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab1BXKRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 05:17:47 -0500
Message-ID: <4D663044.3080000@redhat.com>
Date: Thu, 24 Feb 2011 12:17:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
 boot
References: <20110223234258.GA29548@nik-comp.lan>
In-Reply-To: <20110223234258.GA29548@nik-comp.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 01:42 AM, Nikola Ciprich wrote:
> Hello Avi et al,
> seems like I've hit regression in 2.6.37:
> 32bit SMP centos guest stopped booting, they just hang during initrd phase. (haven't tried
> different distros)
> UP guest are OK.
> when I (forcibly) compiled kvm-kmod-2.6.36.2 and used it in 2.6.37, even
> the SMP guests boot fine.
> does somebody have a tip on where the problem could be, or should I bisect this?
> I tried on 2 different machines, host is x86_64, qemu-kvm 0.13.0, 0.14.0.
> If I shall provide more information (or bisect), please let me know.

Bisect is of course great, if laborious.  Meanwhile can you post 'info 
registers' for all cpus?  Is the guest consuming cpu?  kvm_stat output?

-- 
error compiling committee.c: too many arguments to function

