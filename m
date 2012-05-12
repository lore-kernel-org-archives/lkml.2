Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab2ELPnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 11:43:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56700 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754127Ab2ELPnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 11:43:11 -0400
X-Sasl-enc: 5m5T3lmy6uj+zvMSL1QS6CiJn2FQNl2i3thHft5kzhGd 1336837389
Date: Sat, 12 May 2012 08:43:07 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable@vger.kernel.org, linux-pm <linux-pm@lists.linux-foundation.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 3.3.5 regression: resume doesn't switch to X
Message-ID: <20120512154307.GA6023@kroah.com>
References: <4FAE0E88.2030703@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAE0E88.2030703@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2012 at 09:17:28AM +0200, Jiri Slaby wrote:
> Hi,

<side note, it's stable@vger.kernel.org, not stable@kernel.org>

> since update to 3.3.5, my X doesn't show up after resume from
> hibernation anymore. The only thing I see is "resuming..." on the
> console. I can switch to any tty and login in text mode, but cannot
> switch to X despite it is running. I have to restart whole session to
> have X again.
> 
> Now I'm back to 3.3.4 and everything is OK.

Care to run 'git bisect' to find the offending patch?

thanks,

greg k-h
