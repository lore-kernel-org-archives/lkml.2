Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab0JNAor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:44:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48032 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab0JNAoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:44:46 -0400
Message-ID: <4CB65262.3070507@zytor.com>
Date: Wed, 13 Oct 2010 17:44:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com> <4CB64D8F.9080800@zytor.com> <alpine.DEB.2.00.1010131739010.27124@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1010131739010.27124@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2010 05:42 PM, David Rientjes wrote:
> You can already set the lowmem_reserve_ratio via 
> /proc/sys/vm/lowmem_reserve_ratio.

And why is it then so hard to put in a single line in /etc/sysctl.conf
for you?

> We've run without ZONE_DMA for a couple years because we don't have such 
> hardware limitations and would appreciate the ability to disable it with a 
> config option rather than hacking the kernel to get it to compile.  I'm 
> sure Casey would as well as you can see in the thread "A question about 
> ZONE_DMA".
> 
> I don't see the harm in being able to conveniently disable the zone if you 
> know what you're doing.

There are going to be a lot of very strange bug reports as a result.

	-hpa
