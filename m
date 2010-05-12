Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab0ELXtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:49:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44246 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100Ab0ELXtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:49:22 -0400
Message-ID: <4BEB3CD5.9060803@zytor.com>
Date: Wed, 12 May 2010 16:42:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Borislav Petkov <borislav.petkov@amd.com>, Jiri Kosina <jkosina@suse.cz>,
       "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>,
       "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
       Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>, Jiri Benc <jbenc@suse.cz>,
       Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [stable] [113/197] x86, cacheinfo: Calculate L3 indices
References: <20100422190917.467545308@kvm.kroah.org> <alpine.LNX.2.00.1005051736080.9849@pobox.suse.cz> <20100505180228.GC15804@aftab> <alpine.LNX.2.00.1005052328000.9849@pobox.suse.cz> <20100506081721.GA20616@aftab> <alpine.LNX.2.00.1005061532390.9849@pobox.suse.cz> <20100506141358.GB20994@aftab> <20100512231906.GB3588@kroah.com> <4BEB3A77.1020907@zytor.com>
In-Reply-To: <4BEB3A77.1020907@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 04:32 PM, H. Peter Anvin wrote:
> On 05/12/2010 04:19 PM, Greg KH wrote:
>>>
>>> So if K8_NB has failed initializing for some reason, we never go near
>>> the pci devs and the node_to_k8_nb_misc() calls since we effectively
>>> disable the L3 functionality.
>>>
>>> Thus the NULL pointer checks you remove in the patch below are
>>> superfluous, I agree, and I have already removed those in my tree along
>>> with the other improvements/fixes I'm working on right now.
>>
>> So, was there ever a patch applied that fixed the bug that Jiri found in
>> the stable kernels with this original patch that I could apply?
>>
> 
> Sounds like this patch in -tip should be promoted to mainline/stable...
> could the AMD people please confirm?
> 

Specifically, "waiting to hit mainline" is not an option since they are
currently queued for .35, but we need a minimal fix in .34 -- this is
the "stable backport".  If this "stable backport" is simply a subset of
the patch series then let me know which ones should be moved to urgent
and sent to Linus immediately.  I obviously don't have access to a setup
which can replicate this particular problem.

	-hpa
