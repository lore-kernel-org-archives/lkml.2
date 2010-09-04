Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0IDSqO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 14:46:14 -0400
Received: from THUNK.ORG ([69.25.196.29]:44367 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab0IDSqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 14:46:13 -0400
Date: Sat, 4 Sep 2010 14:46:11 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
Message-ID: <20100904184611.GC4887@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	linux-kernel@vger.kernel.org
References: <201007110918.42120.Martin@lichtvoll.de>
 <201007111651.42963.Martin@lichtvoll.de>
 <20100711172252.GA3379@1wt.eu>
 <201009041839.09261.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009041839.09261.Martin@lichtvoll.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 06:38:59PM +0200, Martin Steigerwald wrote:
> 
> During bisecting [Bug 16376] random - possibly Radeon DRM KMS related 
> freezes, which goes very slowly due to having lots of unbootable kernels 
> with an ext4 / readahead related backtrace during boot, I had an idea:

So I'm not sure what you're referring to here.  If there's an ext4
bug, why haven't you reported it to the linux-ext4 list?  I've done a
Google search for "Steigerwald ext4 readahead" and I can't find any
bug report related to kernel oops that are ext4/readahead-related.

No one else has reported such a bug to me, and I run a complete set of
regression tests before I push ext4 changes to Linus.  So I'm not sure
what you're seeing.  But complaining about it in passing on an e-mail
without sending a formal bug report to the linux-ext4 mailing list is
not likely to solve your problem...

						- Ted
