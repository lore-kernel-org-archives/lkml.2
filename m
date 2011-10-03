Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab1JCJYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:24:30 -0400
Received: from edison.jonmasters.org ([173.255.233.168]:43146 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab1JCJYX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:24:23 -0400
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=us-ascii
From: Jon Masters <jonathan@jonmasters.org>
In-Reply-To: <20111003084407.GC18195@e102109-lin.cambridge.arm.com>
Date: Mon, 3 Oct 2011 05:24:27 -0400
Cc: Mark Salter <msalter@redhat.com>,
        "ming.lei@canonical.com" <ming.lei@canonical.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C8392961-1EBF-410F-9214-05C060FD6D24@jonmasters.org>
References: <1314826214-22428-1-git-send-email-msalter@redhat.com> <1314826214-22428-3-git-send-email-msalter@redhat.com> <CAHkRjk7ZMDQh8sYf7N_4LLS12JU2ps8dkC34gNWNH+-Zp0p8Rg@mail.gmail.com> <1315319837.2313.1.camel@deneb.redhat.com> <CAHkRjk6TD4Qg-b3nkCE_wwj-tWr-_5evndxo3f+_6gtXEV6gNg@mail.gmail.com> <1315321331.2313.10.camel@deneb.redhat.com> <026571E7-67F6-4B0F-998C-2A845AA22E59@jonmasters.org> <20111003084407.GC18195@e102109-lin.cambridge.arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
X-Mailer: Apple Mail (2.1244.3)
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Re: [PATCH 2/3] define ARM-specific dma_coherent_write_sync
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 3, 2011, at 4:44 AM, Catalin Marinas wrote:

> On Mon, Oct 03, 2011 at 02:40:19AM +0100, Jon Masters wrote:
>> On Sep 6, 2011, at 11:02 AM, Mark Salter wrote:
>>> In any case, the current thinking is that the original problem with
>>> the USB performance seen on cortex A9 multicore is probably something
>>> more than just write buffer delays. Once the original problem is better
>>> understood, we can take another look at this patch if it is still
>>> needed.
>> 
>> Thanks again for looking into this Mark. My understanding is that this
>> is still being investigated. I'll followup with ARM to see how that's
>> going since I've heard nothing recently :) Meanwhile, we're continuing
>> to carry a hack based on these patches in Fedora ARM kernels.
> 
> Not talking about hardware specifics here, the architecture (though
> ARMv7 onwards) mandates that the write buffer is eventually drained. But
> doesn't state any upper limit, so it could even be half a second.

<snip mechanics of dma_coherent_write_sync, etc.>

I guess my main question is, do you think this is just a write buffer delay? If you do, then we should definitely get back to this question of defining DMA extensions. But are we sure that's what this is?

Mark: did you have any more insight into this recently?

Jon.

