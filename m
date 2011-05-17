Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1EQJRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:17:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab1EQJRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:17:33 -0400
Message-ID: <4DD23CF0.3090108@redhat.com>
Date: Tue, 17 May 2011 12:16:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Fenghua Yu <fenghua.yu@intel.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] Enable SMEP CPU Feature
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com> <20110517070308.GC22305@elte.hu>
In-Reply-To: <20110517070308.GC22305@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 10:03 AM, Ingo Molnar wrote:
> * Fenghua Yu<fenghua.yu@intel.com>  wrote:
>
> >  From: Fenghua Yu<fenghua.yu@intel.com>
> >
> >  Intel new CPU supports SMEP (Supervisor Mode Execution Protection). SMEP
> >  prevents kernel from executing code in application. Updated Intel SDM describes
> >  this CPU feature. The document will be published soon.
> >
> >  Note: This patch set doesn't enable the SMEP feature in KVM. If it's needed,
> >  another patch will be pushed for enabling the feature in KVM.
>
> We can do it separately from native kernel support, but i'm sure Avi would
> agree that SMEP support in KVM would be nice!

Definitely.

> (as long as it's configurable as
> well, there might be guest OSs that break if SMEP is enabled, right?)

As mentioned earlier, the simple thing is to expose smep and let the 
guest enable it itself.

-- 
error compiling committee.c: too many arguments to function

