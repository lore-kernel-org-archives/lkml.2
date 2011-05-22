Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab1EVLA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 07:00:58 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50470 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab1EVLAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 07:00:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=W7fvaLgj4ValvER9o0p/IXByUf2r3pEisCjAIGeUKE9S68BKxrsl3wGILMgnJD1bCB
         dih4V7xmrqO4p4A+Nv9jnF5SHvyWeeGr7dhAyWAU9//894e+77iZOduoeOC9CKLEBXNV
         AurbTD0zCLaNP+SYDyEDxog4hTfYLGCdy7AY8=
Message-ID: <4DD8ECD9.6080300@gmail.com>
Date: Sun, 22 May 2011 15:00:41 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        heil@terminal-consulting.de, penberg@kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        KVM devel mailing list <kvm@vger.kernel.org>
Subject: Re: [tip:tools/kvm] kvm tools: Add conditional compilation of symbol
 resolving
References: <tip-c474e3fec70bcacd5b24a24838c653e5a13e7b58@git.kernel.org> <20110522105816.GA13373@elte.hu>
In-Reply-To: <20110522105816.GA13373@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2011 02:58 PM, Ingo Molnar wrote:
> 
> * tip-bot for Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
>> diff --git a/tools/perf/feature-tests.mak b/tools/kvm/config/feature-tests.mak
>> similarity index 83%
>> copy from tools/perf/feature-tests.mak
>> copy to tools/kvm/config/feature-tests.mak
> 
> Btw, now that we have feature-tests.mak it would be nice to populate the checks 
> for the various assumptions.
> 
> One i recently ran into on a new box where i tried to install tools/kvm was:
> 
> In file included from /usr/include/features.h:387:0,
>                  from /usr/include/unistd.h:26,
>                  from include/kvm/util.h:12,
>                  from bios/e820.c:5:
> /usr/include/gnu/stubs.h:7:27: fatal error: gnu/stubs-32.h: No such file or directory
> compilation terminated.
> make: *** [bios/bios-rom.bin] Error 1
> 
> that's a dependency on glibc-dev[el].
> 
> Thanks,
> 
> 	Ingo

  Ouch. I've been hitting this lack of gnu/stubs-32.h on Fedora 15 too and eventually
I had to install i686 packages for devel. I'll try to resolve this issue tonight, I
suppose it's not absolutely urgent, right?

-- 
    Cyrill
