Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1GRIVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 04:21:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749Ab1GRIVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 04:21:08 -0400
Message-ID: <4E23ECEA.90803@redhat.com>
Date: Mon, 18 Jul 2011 11:20:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, kvm@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: linux-next: Tree for July 16 (kvm)
References: <20110717000815.c83755be9598d34ac8431908@canb.auug.org.au> <20110716115719.feedaeb2.rdunlap@xenotime.net>
In-Reply-To: <20110716115719.feedaeb2.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2011 09:57 PM, Randy Dunlap wrote:
> On Sun, 17 Jul 2011 00:08:15 +1000 Stephen Rothwell wrote:
>
> >  Hi all,
> >
> >  Changes since 20110707:
>
>
> kvmclock.c:(.text+0x2778e): undefined reference to `kvm_disable_steal_time'
>
> Full kernel config file is attached.
>

CONFIG_KVM_CLOCK && !CONFIG_KVM_GUEST.

What to do?  Stick a wrmsr_safe() in kvmclock.c?  Move kvm_disable 
steal_time() inline? what about has_steal_clock?

-- 
error compiling committee.c: too many arguments to function

