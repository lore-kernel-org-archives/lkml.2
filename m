Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1AYWQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:16:11 -0500
Received: from xenotime.net ([72.52.115.56]:56208 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752663Ab1AYWQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:16:09 -0500
Date: Tue, 25 Jan 2011 14:16:05 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mark Lord <kernel@teksavvy.com>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86-ML <x86@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk upon
 panic
Message-Id: <20110125141605.43963105.rdunlap@xenotime.net>
In-Reply-To: <4D3F4A69.7090702@teksavvy.com>
References: <20110125134748.GA10051@laptop>
	<20110125140948.GA26762@elte.hu>
	<20110125153649.GA11386@laptop>
	<1295971355.4955.104.camel@mulgrave.site>
	<20110125170522.GA16285@laptop>
	<4D3F4A69.7090702@teksavvy.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 17:10:49 -0500 Mark Lord wrote:

> On 11-01-25 12:05 PM, Ahmed S. Darwish wrote:
> >
> > My current x86 laptop includes the very common ATA PIIX controller. 
> 
> 
> ata_piix is just about ideal for this sort of thing.
> 
> Except, don't use the BIOS to write the logs,
> but rather code/use a very simple set of polling-PIO
> functions to talk directly through the PIIX to the drive.
> 
> Really really simple code to do that, and it would likely
> work with anything ata-piix, and most other non-AHCI chipsets too.
> 
> Not perfect, but probably good enough for a lot of scenarios.
> The old hd.c driver shows how to read/write a sector at a time,
> and that kind of code is easily converted to simply poll for completion.

I don't know how/where to find it, but Rusty Russell had a version of this
many, many years ago.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
