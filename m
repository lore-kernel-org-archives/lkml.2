Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab2GFMpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:45:01 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37296 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab2GFMo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:44:59 -0400
Date: Fri, 6 Jul 2012 08:44:32 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
        zakir@umich.edu, greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net
Subject: Re: [PATCH 00/10] /dev/random fixups
Message-ID: <20120706124432.GA10798@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
	zakir@umich.edu, greg@kroah.com, mpm@selenic.com,
	nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
	davem@davemloft.net
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
 <20120706114032.GA28951@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706114032.GA28951@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 07:40:32PM +0800, Fengguang Wu wrote:
> Hi Theodore,
> 
> I got this lockdep warning in linux-next. I've not bisected it..
> however seems most related to this patchset.

Thanks, I know what caused it.  I'll fix that in my next spin of the
patches....

						- Ted
