Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab1HWUUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 16:20:33 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35775 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486Ab1HWUU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 16:20:26 -0400
X-Sasl-enc: e9qqmqHc79pbc3odwdFX+khSCQGsAT+JM6fiJaakBLQJ 1314130826
Date: Tue, 23 Aug 2011 13:18:47 -0700
From: Greg KH <greg@kroah.com>
To: Keng-Yu Lin <kengyu@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: add Realtek rts5139 card reader driver
Message-ID: <20110823201847.GE25977@kroah.com>
References: <1313044402-12445-1-git-send-email-kengyu@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313044402-12445-1-git-send-email-kengyu@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 02:33:21PM +0800, Keng-Yu Lin wrote:
> Realtek RTS5139 USB card reader driver supporting SD, MMC, MS and XD.
> 
> Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
> ---
>  drivers/staging/Kconfig                    |    2 +
>  drivers/staging/Makefile                   |    1 +
>  drivers/staging/rts5139/Kconfig            |    7 +

Ok, WTF is going on here?

You just resent a patch that I got previously from RealTek, with their
proper authorship information on it, yet you do not have that authorship
on this patch at all.

You do NOT just blindly strip off the proper authorship information from
a patch.  That's wrong and can get you in lots of trouble.

Please go work with your managers to fix your development proceedures as
they are deeply broken if this is something that they are allowing you
to send out.

Ugh, this makes me mad...

greg k-h
