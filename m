Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab1FHIyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 04:54:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48658 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487Ab1FHIyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 04:54:10 -0400
Date: Wed, 8 Jun 2011 10:53:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86: Readd asmregparm
Message-ID: <20110608085355.GA1692@elte.hu>
References: <1307495401-2631-1-git-send-email-andi@firstfloor.org>
 <20110608081957.GA14966@elte.hu>
 <20110608083750.GH27166@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608083750.GH27166@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > That's a totally useless changelog (you are deliberately hiding 
> > information again) so the series is obviously not acceptable.
> > Please fix and resend.
> 
> I reread it and it seems complete to me. Please be more specific.
> 
> If you refer to the followon patchkit - it's not ready for posting 
> yet. [...]

You contradict yourself here - why do you claim that it's "complete" 
while you readily admit in the *next* sentence that the "followon 
patchkit" (with no specifics provided whatsoever) is "not ready for 
posting yet"?

You are not a newbie anymore, you know what the rules are for 
*everyone*: if it's not ready for posting yet then don't send a 
half-done series for inclusion, wasting everyone's time.

> [...] However I believe these changes are reasonable cleanups that 
> are useful on their own. That's why I posted them now.

Uhm, that's trivially untrue crazy talk and you should know it: the 
patches add code and typing complexity for no good stated reason 
whatsoever.

If we want the maintenance overhead of that then you better come up 
with your deliberately kept secret "project" and we'll be able to 
weigh whether the benefits overweigh the maintenance costs ...

In any case, i'd like to warn you that you are very close to me 
starting to ignore your mails summarily due to absymal low quality: 
in the past few months 70-80% of the cases your first patch 
submissions were trivially flawed, and in many cases you should have 
been well aware of the fact that they were trivially flawed. And 
that's not from a newbie but from a long-time kernel contributor!

Thanks,

	Ingo
