Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965153Ab1GMJQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 05:16:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52787 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965124Ab1GMJQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 05:16:17 -0400
Date: Wed, 13 Jul 2011 11:16:13 +0200
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, tglx@linutronix.de,
        benh@kernel.crashing.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCHSET x86/mm] memblock, x86: Allow node info in memblock and
 remove x86 specific memblock code
Message-ID: <20110713091613.GE2872@htj.dyndns.org>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
 <CAE9FiQUfHB=EtzDBhPr2ntn__0AC0NcCdi0e7NiwmKb0bZmBbg@mail.gmail.com>
 <4E1D0F33.7020708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1D0F33.7020708@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 12, 2011 at 08:21:23PM -0700, H. Peter Anvin wrote:
> On 07/12/2011 04:26 PM, Yinghai Lu wrote:
> > 
> > that is great, merge early_node_map into memblock array.
> > 
> > looks it comes with some mismatch section warning...
> > 
> 
> I'm also confused about the baseline of the patchset...

The whole thing is on top of x86/urgent for the commit which disabled
AMD NUMA on 32bit, so it's like the following.

  x86/urgent (5da0ef9a8 "x86: Disable AMD_NUMA for 32bit for now")

+ Two patches for pfn->nid mapping granularity check (applied now)

    http://thread.gmane.org/gmane.linux.kernel/1166521

+ memblock, x86: Misc cleanups

    http://thread.gmane.org/gmane.linux.kernel.cross-arch/10338

+ memblock, x86: Implement for_each_mem_pfn_range() and use it to improve memblock allocator

    http://thread.gmane.org/gmane.linux.kernel.cross-arch/10345

+ memblock, x86: Allow node info in memblock and remove x86 specific memblock code

    http://thread.gmane.org/gmane.linux.kernel.cross-arch/10354

Thanks.

-- 
tejun
