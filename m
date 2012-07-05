Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365Ab2GEXKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:10:06 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37167 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933237Ab2GEXKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:10:05 -0400
Date: Thu, 5 Jul 2012 19:09:49 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
        zakir@umich.edu, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net
Subject: Re: [PATCH 02/10] random: use lockless techniques when mixing
 entropy pools
Message-ID: <20120705230949.GC15685@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Greg KH <greg@kroah.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
	zakir@umich.edu, mpm@selenic.com, nadiah@cs.ucsd.edu,
	jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
 <1341511933-11169-3-git-send-email-tytso@mit.edu>
 <20120705181956.GA16846@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705181956.GA16846@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 11:19:56AM -0700, Greg KH wrote:
> Any reason you don't want this backported to the -stable series?

That was an oversight; I just missed marking this for -stable.  Thanks
for pointing it out!

					- Ted
