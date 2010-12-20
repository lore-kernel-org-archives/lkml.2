Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab0LTKv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 05:51:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab0LTKvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 05:51:25 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTi=9UZ5BYWo5xT=jh0upRP6PraH4S=t=tL49YRdr@mail.gmail.com>
References: <AANLkTi=9UZ5BYWo5xT=jh0upRP6PraH4S=t=tL49YRdr@mail.gmail.com> <4d0662e511688484b3@agluck-desktop.sc.intel.com> <AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com> <AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com> <AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com> <AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com> <AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com> <4D0BEE1F.7020008@zytor.com> <AANLkTinwFt+KDKNEYP9MWQ7wGb9qk=E2Xa3RJB3+MJnN@mail.gmail.com> <AANLkTinoV_pL=Ygqq4qt4f8c+wsdc9r9K7rcJ58aHjD1@mail.gmail.com> <AANLkTikhtWjFBQmA111Q+2JGRudrRNAmegGThMagr4vF@mail.gmail.com> <20101219091752.GA16150@liondog.tnic> 
To: Tony Luck <tony.luck@intel.com>
Cc: dhowells@redhat.com, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        greg@kroah.com, akpm@linux-foundation.org, ying.huang@intel.com,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [concept & "good taste" review] persistent store
Date: Mon, 20 Dec 2010 10:49:39 +0000
Message-ID: <17090.1292842179@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck <tony.luck@intel.com> wrote:

> I'm not sure how big the store is on my system ... the ACPI/ERST
> interface on this machine limits each entry to just under 8KB. But
> that isn't inherent to to ERST, both larger and smaller values would
> be an option. 8K seems quite useful for kmsg_dump purposes as
> it grabs a significant number of lines leading up to the oops/panic.

How are things written to the store?  Is it a record-based affair?

David
