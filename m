Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030244Ab2GFWAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:00:30 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37401 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932549Ab2GFWA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:00:27 -0400
Date: Fri, 6 Jul 2012 17:59:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Eric Wustrow <ewust@umich.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org, w@1wt.eu, zakir@umich.edu,
        greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org
Subject: Re: [PATCH 01/10] random: make 'add_interrupt_randomness()' do
 something sane
Message-ID: <20120706215958.GA3922@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Eric Wustrow <ewust@umich.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	torvalds@linux-foundation.org, w@1wt.eu, zakir@umich.edu,
	greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
	jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
	stable@kernel.org
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
 <1341511933-11169-2-git-send-email-tytso@mit.edu>
 <CAGsuqq2MWuFnY7PMb_2ddBNNJr80xB_JW+Wryq3mhhmQuEojpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsuqq2MWuFnY7PMb_2ddBNNJr80xB_JW+Wryq3mhhmQuEojpg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 03:01:12PM -0400, Eric Wustrow wrote:
> Will this do the long path in add_interrupt_randomness every 16 interrupts
> instead of 128?

Yes, but given that benchmarks didn't show any performance degradation
even under a worst case scenario (i.e., no interrupt mitigation, and a
crazy number of interrupts/second), I decided to leave things as they
are.

						- Ted
