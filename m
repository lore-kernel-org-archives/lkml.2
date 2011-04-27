Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab1D0OwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:52:16 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:56244 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab1D0OwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:52:15 -0400
Date: Wed, 27 Apr 2011 10:52:09 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: gmack@innerfire.net
Cc: Christoph Hellwig <hch@infradead.org>, Thiago Farina <tfransosi@gmail.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
Message-ID: <20110427145209.GJ9486@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, gmack@innerfire.net,
	Christoph Hellwig <hch@infradead.org>,
	Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
 <20110427005243.GI9486@thunk.org>
 <20110427064719.GB597@infradead.org>
 <alpine.DEB.2.00.1104270445210.7570@mtl.rackplans.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104270445210.7570@mtl.rackplans.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 04:47:40AM -0400, gmack@innerfire.net wrote:
> Knowing about it and not screwing it up are two different things. I was 
> working on a project a few years ago and we made this exact change thanks 
> to the backwards logic of strcmp constantly screwing people up and the bug 
> count went down considerably.

If someone could even vaguely possibly screw up strcmp(), I don't want
them submitting patches to my subsystem.  I'm generally worried about
far more subtle bugs (deadlocks, locking screwups), and as Christoph
said, if you can't notice a strcmp bug, there's something
***seriousl**** wrong with your code review process, test suite,
testing discpline, or all of the above.

I would consider patches to change !strcmp() to streq() in any code I
maintain to be worse noise than spelling patches, or whitespace
patches.

						- Ted
