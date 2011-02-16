Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab1BPUNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:13:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39049 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab1BPUNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:13:52 -0500
Date: Wed, 16 Feb 2011 21:13:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in
 2.6.38-rc4
Message-ID: <20110216201342.GA7766@elte.hu>
References: <20110216185234.GA11636@tiehlicka.suse.cz>
 <20110216193700.GA6377@elte.hu>
 <AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Feb 16, 2011 at 11:37 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > ( Cc:-ed Linus - he was analyzing a similar looking bug a few days ago on lkml.
> >  Mail repeated below. )
> 
> Yup, goodie. It does look like it might be exactly the same thing,
> except now the offset seems to be 0x1e68 instead of 0x1768.
> 
> I'll compile a x86-32 kernel with that config and try to see if I can
> find that offset in there..

Michal, you might also want to try to find it - in case Linus's different compiler 
somehow hides that offset.

Thanks,

	Ingo
