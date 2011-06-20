Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab1FTQrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:47:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43629 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab1FTQrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:47:33 -0400
Message-ID: <4DFF78E9.7010202@zytor.com>
Date: Mon, 20 Jun 2011 09:44:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ryan Mallon <rmallon@gmail.com>, Petr Tesarik <ptesarik@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
References: <201106171038.25988.ptesarik@suse.cz> <20110617093032.GA19235@elte.hu> <4DFE7FF9.9070406@gmail.com> <4DFE89E0.5020509@zytor.com> <20110620074124.GB24716@elte.hu> <4DFF6E58.8090306@zytor.com> <20110620164045.GB10815@elte.hu>
In-Reply-To: <20110620164045.GB10815@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2011 09:40 AM, Ingo Molnar wrote:
> 
> There is no reason why they couldnt use a .config option or a boot 
> option to get their weird stuff going, which weird stuff also happens 
> to be useful.
> 
> What i'm somewhat against is having this enabled by default for weird 
> stuff that also happens to be harmful - and the fact that it never 
> worked over 4G physical gives us the perfect opportunity to do just 
> that.
> 

I'm concerned about that notion.  I think it's fine to modularize
/dev/mem, but what we're seeing is that Red Hat and all kinds of other
entities are putting in ad hoc versions of /dev/mem, but of course doing
so incorrectly.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

