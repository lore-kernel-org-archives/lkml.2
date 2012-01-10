Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663Ab2AJAhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 19:37:33 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33305 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933599Ab2AJAhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 19:37:32 -0500
X-Sasl-enc: NhDnC29z30w3JScJtmL2BQIu+WaJgA4yze3+PDoa6nYy 1326155851
Date: Mon, 9 Jan 2012 16:37:05 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: Latest kernel stable/longterm status
Message-ID: <20120110003705.GA9482@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As 3.2 is now out, here's a note as to the current status of the
different stable/longterm kernel trees.

First off, please everyone remember to mark any patch that you want to
have applied to the stable kernel trees with a simple:
	Cc: stable <stable@vger.kernel.org>
marking in the Signed-off-by: area.  Once the patch hits Linus's tree, I
will automatically be notified of it and it will be applied if possible.
If it does not applied, you will be notified of that.

Note that the address is stable@vger.kernel.org, not the older address
that used to be used before October of 2011.

At this time, all stable and longterm kernel trees are being maintained
in one big git tree, located at:
	git.kernel.org:/pub/scm/linux/kernel/git/stable/linux-stable.git
There are different branches for every different major kernel version.

Here's the different active kernel versions that I am maintaining at the moment:

 3.2.y - this will be maintained until 3.3 comes out
 3.1.y - there will be only one, maybe two, more releases of this tree
 3.0.y - this is the new "longterm" kernel release, it will be
         maintained for 2 years at the minimum by me.
 2.6.32.y - this is the previous "longterm" kernel release.  It is
	    approaching it's end-of-life, and I think I only have
	    another month or so doing releases of this.  After I am
	    finished with it, it might be picked up by someone else, but
	    I'm not going to promise anything.

All other longterm kernels are being maintained in various forms
(usually quite sporadically, if at all), by other people, and I can not
speak for their lifetime at all, that is up to those individuals.

If anyone has any questions about any of this, please let me know.

thanks,

greg k-h
