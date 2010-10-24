Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab0JXEcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 00:32:16 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:10801 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab0JXEcP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 00:32:15 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EACZTw0yrR7Ht/2dsb2JhbACDHp5QcZ5+iiqQd4EigzJ0BIRUhXk
X-IronPort-AV: E=Sophos;i="4.58,230,1286150400"; 
   d="scan'208";a="274673874"
From: Roland Dreier <rdreier@cisco.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] first round of SCSI updates for the merge window
References: <1287764862.8930.220.camel@mulgrave.site>
	<AANLkTikZ-vePH+Wvf9S0-0PG1h+rRNByKEmXC2XENH1=@mail.gmail.com>
	<ada8w1or36h.fsf@cisco.com>
	<AANLkTin+qS+kPZC-T7Ddu9WPbhudSXEObkyCawWisxH9@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 23 Oct 2010 21:32:06 -0700
In-Reply-To: <AANLkTin+qS+kPZC-T7Ddu9WPbhudSXEObkyCawWisxH9@mail.gmail.com>
	(Linus Torvalds's message of "Sat, 23 Oct 2010 15:13:10 -0700")
Message-ID: <adamxq4p5x5.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > >  > There's a _single_ commit that looks like this:
 > >  >
 > >  >  220 files changed, 34823 insertions(+), 43478 deletions(-)
 > >
 > > Hey, you're not using git properly... if I use '-M' to show moved
 > > files, I see:
 > >
 > >  212 files changed, 30007 insertions(+), 38662 deletions(-)
 > >
 > > which is a lot nicer.
 > 
 > It really doesn't make any difference what-so-ever. Lookie here:

Sorry to set you off ... I was being a bit sarcastic, and playing off
your tendency to show off git's ability to track moves.  Being serious,
obviously even after the -M, the commit is ludicrously impossible to
review.

Too dryly,
  Roland
