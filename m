Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab2EGNqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:46:25 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:38418 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab2EGNqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:46:23 -0400
Date: Mon, 7 May 2012 19:16:11 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Attilio Rao <attilio.rao@citrix.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen Devel <xen-devel@lists.xensource.com>, linux-doc@vger.kernel.org,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V8 0/17] Paravirtualized ticket spinlocks
Message-ID: <20120507134611.GB5533@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com>
 <20120507082928.GI16608@gmail.com>
 <4FA7888F.80505@redhat.com>
 <4FA7AAD8.6050003@linux.vnet.ibm.com>
 <4FA7BABA.4040700@redhat.com>
 <4FA7CC05.50808@linux.vnet.ibm.com>
 <4FA7CCA2.4030408@redhat.com>
 <4FA7D06B.60005@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4FA7D06B.60005@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12050713-9574-0000-0000-00000287BF51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> [2012-05-07 19:08:51]:

> I 'll get hold of a PLE mc  and come up with the numbers soon. but I
> 'll expect the improvement around 1-3% as it was in last version.

Deferring preemption (when vcpu is holding lock) may give us better than 1-3% 
results on PLE hardware. Something worth trying IMHO.

- vatsa

