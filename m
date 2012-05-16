Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967188Ab2EPAnC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 20:43:02 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57533 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab2EPAnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 20:43:00 -0400
Date: Wed, 16 May 2012 01:42:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Eric Paris <eparis@parisplace.org>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
Message-ID: <20120516004251.GO22082@ZenIV.linux.org.uk>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
 <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
 <CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
 <CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com>
 <1337112446.20904.50.camel@falcor>
 <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
 <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 05:37:46PM -0700, Linus Torvalds wrote:

> It also makes security_mmap_addr() always call the standard capability
> check (*after* having called the security model version), so the
> security model no longer needs to care. All of them did seem to do so.
> 
> And again: this is totally untested. I'm not committing this, it's
> more of a "hey, I tried it out, might as well send it out for
> comments" thing.

Er...  Looks like you forgot to actually put the patch in there ;-)
