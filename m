Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965092Ab2JZPwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:52:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:34890 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822Ab2JZPwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:52:39 -0400
Date: Fri, 26 Oct 2012 17:52:38 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Florian Fainelli <ffainelli@freebox.fr>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] x86/dt: use linear irq domain for ioapic(s).
Message-ID: <20121026155238.GB8459@linutronix.de>
References: <1343890270-13007-1-git-send-email-thierry.reding@avionic-design.de>
 <502252C8.3090600@linutronix.de>
 <loom.20121019T133451-621@post.gmane.org>
 <6899584.nNROmkLzNS@flexo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <6899584.nNROmkLzNS@flexo>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Florian Fainelli | 2012-10-19 15:40:29 [+0200]:

>On Friday 19 October 2012 11:36:25  Fainelli wrote:
>> Sebastian Andrzej Siewior <bigeasy <at> linutronix.de> writes:
>> > 
>> > No. You do have a compatible entry. It first appeared on the ce4100
>> > CPU. If it happens to also work on the n450 then it seems to be
>> > compatible with that one. "This" is documented somewhere???
>> > Usually you add 'compatible = "your cpu", "generic binding"' in case
>> > you need a fixup / errata whatever for "your cpu". Even if you compare
>> > all hpets from Intel there is the one or other difference / errata.
>> 
>> Can we make sure that his hits the future 3.6 stable releases? We had to merge
>> this back to your 3.6 kernel tree in order to have a functionnal CE4100 system.
>> 
>> Thank you!
>
>Adding Adding Thomas, Ingo and Sebastian in CC.

If someone needs it, yes. My understanding was that Thierry said we need
a few OF specific patches and this alone won't help. Care to backport
and test & post it?

>--
>Florian

Sebastian
