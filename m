Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab2GQRNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:13:30 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39504 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721Ab2GQRNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:13:22 -0400
Date: Tue, 17 Jul 2012 13:12:51 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH -next] random: Remove remaining relicts of
 rand_initialize_irq()
Message-ID: <20120717171251.GD6049@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	Linus Walleij <linus.walleij@stericsson.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>, linux-ia64@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
References: <1342524793-2522-1-git-send-email-sedat.dilek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342524793-2522-1-git-send-email-sedat.dilek@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 01:33:13PM +0200, Sedat Dilek wrote:
> rand_initialize_irq() was removed here:
> 
> commit 946672f548682905d8ecdab33bb6e2c705418505
> "random: remove rand_initialize_irq()"
> 
> The AB3100 mfd-driver is the only driver still using it and breaks
> with the following error-messages in linux-next (next-20120717)

Oops.  Sorry, I thought I had caught all of the users of
rand_initialize_irq().  Thanks for catching this!

I'll take your advice and merge it into the original commit.

     	       	      	  	   	- Ted
