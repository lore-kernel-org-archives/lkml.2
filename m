Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178Ab2ACBK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 20:10:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab2ACBK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 20:10:27 -0500
Date: Mon, 2 Jan 2012 17:08:31 -0800
From: Greg KH <gregkh@suse.de>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: cleanup prohibition of direct opening for unix98
 pty master
Message-ID: <20120103010831.GA21866@suse.de>
References: <20120102172231.11476.57711.stgit@zurg>
 <20120102172844.GA19782@suse.de>
 <4F022FB4.5080703@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F022FB4.5080703@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 02:29:08AM +0400, Konstantin Khlebnikov wrote:
> Greg KH wrote:
> >On Mon, Jan 02, 2012 at 09:22:31PM +0400, Konstantin Khlebnikov wrote:
> >>cleanup hack added in v2.6.27-3203-g15582d3
> >>
> >>comment from that patch:
> >>
> >>: pty: If the administrator creates a device for a ptmx slave we should not error
> >>:
> >>: The open path for ptmx slaves is via the ptmx device. Opening them any
> >>: other way is not allowed. Vegard Nossum found that previously this was not
> >>: the case and mknod foo c 128 42; cat foo would produce nasty diagnostics
> >>:
> >>: Signed-off-by: Alan Cox<alan@redhat.com>
> >>: Signed-off-by: Linus Torvalds<torvalds@linux-foundation.org>
> >
> >Any reason why you didn't include these two people on this patch?
> >Perhaps they might wish to review it...
> 
> This is just simple cleanup patch.

Even so, please resend and copy them.

greg k-h
