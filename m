Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab1JKAI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 20:08:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab1JKAI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 20:08:26 -0400
Date: Mon, 10 Oct 2011 17:07:59 -0700
From: Greg KH <gregkh@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: stable mailing list?
Message-ID: <20111011000759.GA28709@suse.de>
References: <1318290984.7904.127.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318290984.7904.127.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 07:56:23PM -0400, Steven Rostedt wrote:
> I received a bounce from stable@kernel.org. What should we be Ccing to?

You should be marking your patch with a:
	Cc: stable <stable@kernel.org>

and when it hits Linus's tree, I properly pick it up.  Right now, the
mailing list isn't working, and I am considering just having it point to
a vger list as that makes more sense.  I'll ask Dave to set this up when
I land as I'm traveling at the moment...

thanks,

greg k-h
