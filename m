Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab2IGPmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:42:50 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50025 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2IGPmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:42:47 -0400
Date: Fri, 7 Sep 2012 08:40:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: [PATCH] serial: omap: fix compile breakage
Message-ID: <20120907154008.GA21216@kroah.com>
References: <20120907153136.GA8634@kroah.com>
 <1347032059-8901-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347032059-8901-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 06:34:19PM +0300, Felipe Balbi wrote:
> when rebasing patches on top of Greg's tty-next,
> it looks like automerge broke a few things which
> I didn't catch (for whatever reason I didn't
> have OMAP Serial enabled on .config) so I ended
> up breaking the build on Greg's tty-next branch.
> 
> Fix the breakage by re-adding the three missing
> members on struct uart_omap_port.
> 
> Reported-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
> 
> Hi Greg,
> 
> I just fetched your tree again and rebased again just to
> make sure. Everything is fine here, let me know if it
> still applies with fuzz.

That worked, thanks.

greg k-h
