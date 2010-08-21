Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab0HUT4e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 15:56:34 -0400
Received: from solo.fdn.fr ([80.67.169.19]:41611 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab0HUT4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 15:56:33 -0400
Date: Sat, 21 Aug 2010 21:55:59 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH,TRIVIAL] Replace Configure with Enable in description of MAXSMP
Message-ID: <20100821195559.GC4760@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Nick Piggin <npiggin@kernel.dk>
References: <20100821193241.GB4760@const.famille.thibault.fr> <AANLkTi=Pha8jRFhr+kQfh9doKZDW-=VHq2KqNxXaq6ts@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=Pha8jRFhr+kQfh9doKZDW-=VHq2KqNxXaq6ts@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds, le Sat 21 Aug 2010 12:45:12 -0700, a écrit :
> What broken patch-generation tools do you use, btw?

Well, git diff actually :) But then editted by hand.

> Nick Piggin has the same problem: the Subject of the patch gets
> repeated as the first line of the body of the thing, which is very
> annoying.

Ah, I didn't realize you scripts include the subject topic too. Maybe it
should be said in SubmittingPatches that the "summary phrase" shouldn't
be repeated in the body.

Samuel
