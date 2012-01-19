Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab2ASTlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:41:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55385 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675Ab2ASTlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:41:35 -0500
Date: Thu, 19 Jan 2012 20:41:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael D Labriola <mlabriol@gdeb.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Kushal Koolwal <kushalkoolwal@gmail.com>, linux-kernel@vger.kernel.org,
        michael.d.labriola@gmail.com, Matthew Garrett <mjg59@srcf.ucam.org>,
        support@versalogic.com, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Subject: Re: [PATCH] x86, reboot: skip DMI checks if reboot set by user
Message-ID: <20120119194108.GB28362@elte.hu>
References: <OF70B406E9.8D4A6789-ON85257988.0052C104-85257988.0053DE1E@gdeb.com>
 <20120117195841.48fe8236@pyramind.ukuu.org.uk>
 <OFD4BB6876.6D903346-ON8525798A.00550E62-8525798A.005562A3@gdeb.com>
 <20120119154504.710e202e@pyramind.ukuu.org.uk>
 <OF8642E997.5ED041E1-ON8525798A.0056983A-8525798A.0056E05B@LocalDomain>
 <OF2B909250.6078896E-ON8525798A.0058FF49-8525798A.0061AEA1@gdeb.com>
 <4F18584F.7060603@zytor.com>
 <OFE1B368BB.B6249713-ON8525798A.00692513-8525798A.0069B44E@gdeb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFE1B368BB.B6249713-ON8525798A.00692513-8525798A.0069B44E@gdeb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael D Labriola <mlabriol@gdeb.com> wrote:

> > Yes, and such a patch would be appreciated.
> > 
> > The reason it is as it is dates back to before the 32-64 bit 
> > unification, as far as I know.
> > 
> > (BIOS reboot is currently not supported on 64 bits, mainly.)
> 
> Well, that does complicate it a bit.  I'll gin something up 
> and see what you think.  I guess it will involve having an
> #ifdef CONFIG_X86_32 block inside a single dmi_table structure
> for the BIOS quirks.

Btw., i'd suggest to keep the two changes in separate patches, 
so that if any causes problems we can bisect to it separately. 
The more patches you can reasonably split it up into, the 
better.

Thanks,

	Ingo
