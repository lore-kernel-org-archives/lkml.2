Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab1LRIpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 03:45:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51185 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab1LRIpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 03:45:43 -0500
Date: Sun, 18 Dec 2011 09:43:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Beulich <JBeulich@suse.com>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix and improve percpu_cmpxchg{8,16}b_double()
Message-ID: <20111218084351.GG4144@elte.hu>
References: <4EE86D6502000078000679FE@nat28.tlf.novell.com>
 <4EEB662A.9070308@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEB662A.9070308@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 12/14/2011 12:33 AM, Jan Beulich wrote:
> > 
> > At once also change the return value type to what it really is -
> > 'bool'.
> > 
> 
> I have a hazy memory of "bool" not working correctly in inline assembly,
> but it might be ancient history by now.

I too have memory of badness - but i think it was something 
about suboptimal code generated. We'll see any stability 
problems soon enough, now that it's committed :-)

Thanks,

	Ingo
