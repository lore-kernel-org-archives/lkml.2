Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1JWLtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 07:49:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35931 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755392Ab1JWLty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 07:49:54 -0400
Date: Sun, 23 Oct 2011 13:48:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, microcode, AMD: Add microcode revision to
 /proc/cpuinfo
Message-ID: <20111023114821.GE5156@elte.hu>
References: <1318865115-9904-1-git-send-email-bp@amd64.org>
 <1318865115-9904-3-git-send-email-bp@amd64.org>
 <20111018062509.GE16304@elte.hu>
 <20111019142057.GA26786@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019142057.GA26786@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Borislav Petkov <bp@amd64.org> wrote:

> On Tue, Oct 18, 2011 at 02:25:10AM -0400, Ingo Molnar wrote:
> > The standard way we mention commits in changelogs is:
> > 
> >   Enable microcode revision output for AMD after commit 506ed6b53e00 
> >   ("x86, intel: Output microcode revision in /proc/cpuinfo") did it 
> >   for Intel.
> > 
> > ... because humans are pretty bad at transforming sha1's to the real 
> > commit title when reading such text.
> 
> Why, I thought transforming sha1's to commit messages is one of the job
> requirements of serious kernel hackers.
> 
> :-)

But they are not the only ones reading changelogs ;-)

> > Please fix the changelog for the first commit as well.
> 
> Done, git branch at
> 
> git://amd64.org/linux/bp.git tip-ucode
> 
> updated.

Pulled, thanks,

	Ingo
