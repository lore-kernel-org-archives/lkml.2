Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab1BAWYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:24:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:60323 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab1BAWYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:24:09 -0500
Date: Tue, 1 Feb 2011 14:23:42 -0800
From: Greg KH <gregkh@suse.de>
To: Kevin Hilman <khilman@ti.com>
Cc: linux-omap@vger.kernel.org, "Govindraj.R" <govindraj.raja@ti.com>,
        open list <linux-kernel@vger.kernel.org>,
        Thomas Weber <weber@corscience.de>
Subject: Re: [PATCHv4] OMAP: Enable Magic SysRq on serial console ttyOx
Message-ID: <20110201222342.GA19137@suse.de>
References: <1296545441-17070-1-git-send-email-weber@corscience.de>
 <87ei7ryavx.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ei7ryavx.fsf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 08:31:30AM -0800, Kevin Hilman wrote:
> Thomas Weber <weber@corscience.de> writes:
> 
> > Magic SysRq key is not working for OMAP on new serial
> > console ttyOx because SUPPORT_SYSRQ is not defined
> > for omap-serial.
> >
> > This patch defines SUPPORT_SYSRQ in omap-serial and
> > enables handling of Magic SysRq character.
> >
> > Further there is an issue of losing first break character.
> > Removing the reset of the lsr_break_flag fixes this issue.
> >
> > Signed-off-by: Thomas Weber <weber@corscience.de>
> > Acked-by: Govindraj.R <govindraj.raja@ti.com>
> > Tested-by: Manjunath G Kondaiah <manjugk@ti.com>
> > Acked-by: Kevin Hilman <khilman@ti.com>
> 
> Greg,
> 
> Will you be taking this?  If you prefer, we can take it via OMAP tree
> with your ack.

I can take it if it's not a problem for you.  Or if you want to, please
add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to the patch.

Let me know which is easier for you.

thanks,

greg k-h
