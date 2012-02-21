Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2BUMmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 07:42:46 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:47972 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab2BUMmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 07:42:44 -0500
Date: Tue, 21 Feb 2012 07:42:40 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 3.3.0-rcX: kjournald
Message-ID: <20120221124240.GB5134@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Bob Tracy <rct@gherkin.frus.com>, linux-kernel@vger.kernel.org
References: <20120221054159.GA1919@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221054159.GA1919@gherkin.frus.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 11:41:59PM -0600, Bob Tracy wrote:
> I'm not sure if I caught a complete instance of this in "syslog", but
> here's what I've been seeing with 3.3.0-rc[1-3] kernels.  Shortly after
> booting multi-user, logging in, and attempting a package build, the
> "fun" starts: the following message scrolls repeatedly (possibly with
> different details) across the console.  To date, I've had to hit the
> reset switch to recover, which is why I'm not sure whether I caught a
> complete syslog entry.

Hmm..  I've taken a quick look at fs/jbd/commit.c, and I don't see
anything obvious.  Can you try compiling with LOCKDEP compiled and see
if you can reproduce it, so we can see what spin lock is being held?

Thanks,

						- Ted
