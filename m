Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028Ab2GLP1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 11:27:45 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:38715 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528Ab2GLP1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 11:27:43 -0400
Date: Thu, 12 Jul 2012 11:27:40 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Richard Fontana <fontana2012@gmail.com>, "Bradley M. Kuhn" <bkuhn@ebb.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] copyleft-next: embrace the Signed-off-by practice
Message-ID: <20120712152740.GB14792@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Richard Fontana <fontana2012@gmail.com>,
	"Bradley M. Kuhn" <bkuhn@ebb.org>, linux-kernel@vger.kernel.org
References: <1342053889-32066-1-git-send-email-mcgrof@do-not-panic.com>
 <1342053889-32066-5-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342053889-32066-5-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 05:44:49PM -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> The idea is taken from Linus Torvald's subsurface
> project [0] README file. The Signed-off-by is widely
> used in public projects and we stand to gain to make
> its usage more prevalent. The meaning of the
> Signed-off-by is borrowed from the Linux kernel's.
> 
> [0] git://github.com/torvalds/subsurface.git
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

I wonder why you're cc'ing the linux-kernel mailing list?  I've
checked the copyleft-next clause, and the anti-Tivoization clauses,
which was one of the primary reasons articulated by many kernel
developers --- including Linus Torvalds --- for not using GPLv3, is
still in the Copyleft-next license.

My understanding of Richard Fontana's past public positions was that
he was supportive of that part of the GPLv3 license, and so I had
assumed the Copyleft-next effort would be irrelevant as far as the
Linux Kernel was concerned.

Even if I am wrong about that (and I would be delighted if the answer
was that one of the Copyright-next's goals was to resolve this barrier
of the kernel moving off of GPLv2), it still would seem to me to be
out of scope of the LKML.

Regards,

							- Ted
