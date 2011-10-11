Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1JKMDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 08:03:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab1JKMDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 08:03:11 -0400
Date: Tue, 11 Oct 2011 05:57:13 -0600
From: Greg KH <gregkh@suse.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jiri Kosina <trivial@kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] h8300: drivers/serial/Kconfig was moved
Message-ID: <20111011115713.GC9039@suse.de>
References: <1318332209.18122.45.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318332209.18122.45.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 01:23:29PM +0200, Paul Bolle wrote:
> commit ab4382d27412e7e3e7c936e8d50d8888dfac3df8 moved
> drivers/serial/Kconfig to drivers/tty/serial/Kconfig, so we need to
> source the latter file.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> The first release with this move was v2.6.38. Didn't anyone notice?

I'm guessing no one uses the h8300 arch anymore?

> Perhaps the configuration tools silently skip invalid "source" files.
> Anyhow, I added Yoshinori Sato, who perhaps can tell us whether sourcing
> of this Kconfig is still needed for h8300.

That would be good to find out.

greg k-h
