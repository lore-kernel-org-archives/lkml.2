Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab1JRGMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:12:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44563 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab1JRGME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:12:04 -0400
Date: Tue, 18 Oct 2011 08:09:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v5 10/10] x86, efi: EFI boot stub support
Message-ID: <20111018060947.GB16304@elte.hu>
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>
 <1318848017-12301-11-git-send-email-matt@console-pimps.org>
 <4E9C5A4D.7090802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9C5A4D.7090802@gmail.com>
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


* Maarten Lankhorst <m.b.lankhorst@gmail.com> wrote:

[ a 833 lines of TOTALLY POINTLESS QUOTE ]

> > +			status = low_alloc(options_size, 1, &cmdline);
> > +			if (status != EFI_SUCCESS)
> > +				goto fail;
> Shouldn't this be options_size + 1?
> > +
> > +			s1 = (u8 *)(unsigned long)cmdline;
> > +			s2 = (u16 *)options;
> > +
> > +			for (i = 0; i < options_size - 1; i++)
> > +				*s1++ = *s2++;
> > +
> > +			*s1 = '\0';
> For this null character..
> > +		}

[ another 700+ lines of TOTALLY POINTLESS QUOTE ]

It took me 3 attempts to find your comments in the 1500 lines of 
email.

Please format your emails! If you quote on 20 lines of patch then you 
absolutely HAVE TO cut out the remaining 1500 lines you did not 
comment on ...

Thanks,

	Ingo
