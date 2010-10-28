Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab0J1QCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 12:02:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38179 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758884Ab0J1QB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 12:01:58 -0400
Date: Thu, 28 Oct 2010 18:01:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Huang Ying <ying.huang@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, "Luck, Tony" <tony.luck@intel.com>,
        BorislavPetkov <petkovbb@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v3 0/8] ACPI, APEI patches for 2.6.37
Message-ID: <20101028160129.GA12628@elte.hu>
References: <1288157312-10441-1-git-send-email-ying.huang@intel.com>
 <1288174050.15336.1507.camel@twins>
 <20101027172343.GB22171@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027172343.GB22171@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Peter,
> 
> > All you've done is decreased the arch/x86/ footprint of the patch series, but 
> > neither you nor Andi have addressed the technical arguments against adding this 
> > ABI.
> 
> What were the technical arguments? I don't remember any.

You did not reply to my technical arguments:

    http://lkml.org/lkml/2010/10/25/271

You did not reply to Thomas's technical arguments:

    http://lkml.org/lkml/2010/10/26/71

Are you really claiming that you "don't remember any"?

	Ingo
