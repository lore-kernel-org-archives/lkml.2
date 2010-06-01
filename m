Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750746Ab0FAEKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 00:10:35 -0400
Received: from thunk.org ([69.25.196.29]:54855 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab0FAEKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 00:10:33 -0400
Date: Tue, 1 Jun 2010 00:10:28 -0400
From: tytso@mit.edu
To: Alex Buell <alex.buell@munted.org.uk>
Cc: Mailing Lists - Kernel Developers <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>
Subject: Re: Article in Phoronix about loss of performance in 2.6.35
 release candidates
Message-ID: <20100601041028.GB4426@thunk.org>
Mail-Followup-To: tytso@mit.edu, Alex Buell <alex.buell@munted.org.uk>,
	Mailing Lists - Kernel Developers <linux-kernel@vger.kernel.org>,
	Eric Paris <eparis@redhat.com>
References: <1275347969.29006.5.camel@lithium.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275347969.29006.5.camel@lithium.local.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 12:19:29AM +0100, Alex Buell wrote:
> http://www.phoronix.com/vr.php?view=14976
> 
> Question: Why?

One of the theories that has been advanced is that it's simply this
problem:

	http://lkml.org/lkml/2010/5/22/154

If so, it points out how idiotic Phoronix is about not being able to
notice udev pegging the CPU at 100% being someone bad for its
benchmark runs.  :-)

OTOH, this bug has been known for over a week, and it is sort sad that
we haven't reverted this patch.  It looks like the conversation has
died, but without a fix?

						- Ted
