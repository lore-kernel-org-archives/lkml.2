Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab2BIOqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:46:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55634 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab2BIOqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:46:19 -0500
Message-ID: <4F33DC0F.7090704@zytor.com>
Date: Thu, 09 Feb 2012 06:45:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Hitoshi Mitake <h.mitake@gmail.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Kashyap Desai <Kashyap.Desai@lsi.com>, Len Brown <lenb@kernel.org>,
        Ravi Anand <ravi.anand@qlogic.com>,
        Vikas Chaudhary <vikas.chaudhary@qlogic.com>,
        Matthew Garrett <mjg@redhat.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        James Bottomley <James.Bottomley@parallels.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Roland Dreier <roland@purestorage.com>,
        James Bottomley <jbottomley@parallels.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] asm-generic: architecture independent readq/writeq for
 32bit environment
References: <1328582733-31804-1-git-send-email-h.mitake@gmail.com> <2d1a4f3c-48b0-4105-bbc6-18d164512405@email.android.com> <CAMO-S2h-maRLhkX255XX=TPrMH5d5F_3w-aJr7g=GRHcQ+LAXg@mail.gmail.com>
In-Reply-To: <CAMO-S2h-maRLhkX255XX=TPrMH5d5F_3w-aJr7g=GRHcQ+LAXg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2012 05:37 AM, Hitoshi Mitake wrote:
> On Tue, Feb 7, 2012 at 12:47, hpanvin@gmail.com<hpa@zytor.com>  wrote:
>> Should be volatile u64 * not volatile void *...
>
> Is this the type of parameters?
> The parameters of atomic readq/writeq defined in arch/x86/include/asm/io.h
> are defined as void *. I think that atomic readq/writeq and non-atomic
> readq/writeq
> should have same typed parameters and return values.
>

That sounds like a bug.

	-hpa

