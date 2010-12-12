Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab0LLJXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 04:23:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab0LLJXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 04:23:31 -0500
Message-ID: <4D049488.5020105@redhat.com>
Date: Sun, 12 Dec 2010 11:23:20 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Glauber Costa <glommer@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, kvm@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 22 (kvm)
References: <20101122134911.b7e106f9.sfr@canb.auug.org.au>	<20101122132627.bd4e88ef.randy.dunlap@oracle.com>	<20101129083324.6870d7da.randy.dunlap@oracle.com>	<4CF3D637.6060204@redhat.com>	<4CF3E733.8090809@redhat.com>	<4CF3E870.4040308@oracle.com>	<4CF3EC1E.7050707@redhat.com> <20101210091859.63a6a43e.randy.dunlap@oracle.com>
In-Reply-To: <20101210091859.63a6a43e.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2010 07:18 PM, Randy Dunlap wrote:
> >  Looks like this is the appropriate fix:
> >
> >  #ifdef CONFIG_SMP
> >  static void __init kvm_smp_prepare_boot_cpu(void)
> >  {
> >  #ifdef CONFIG_KVM_CLOCK
> >  	WARN_ON(kvm_register_clock("primary cpu clock"));
> >  #endif
> >  	kvm_guest_cpu_init();
> >  	native_smp_prepare_boot_cpu();
> >  }
>
>
> Can we get this fix merged, please?
>
> Build error is still happening in linux-next 20101210.
>

Zach, a proper patch please.

-- 
error compiling committee.c: too many arguments to function

