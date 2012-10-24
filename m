Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935493Ab2JXSsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:48:51 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44100 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935265Ab2JXSsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:48:50 -0400
Date: Wed, 24 Oct 2012 22:48:45 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
        xemul@parallels.com, jslaby@suse.cz
Subject: Re: [patch 0/3] TTY flags fetching
Message-ID: <20121024184845.GW30983@moon>
References: <20121016094622.337128953@openvz.org>
 <20121024183817.GA18381@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024183817.GA18381@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 11:38:17AM -0700, Greg KH wrote:
> On Tue, Oct 16, 2012 at 01:46:22PM +0400, gorcunov@openvz.org wrote:
> > Hi guys, I've updated the series on top of current tty-next Greg's tree.
> > The series introduces new ioctl codes TIOCGPKT, TIOCGPTLCK, TIOCGEXCL to
> > fetch pty's packet mode and locking state, and exclusive mode of it, which
> > we really need to know when we do checkpoint-restore transition.
> > 
> > Please review, thanks!
> 
> Your email address is messed up (no name, just an address), so I can't
> apply these patches.  Care to fix that up and resend?

Yeah, Greg, I'll update and resend, sorry for inconvenience.
