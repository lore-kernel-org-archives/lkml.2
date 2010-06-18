Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0FRWby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 18:31:54 -0400
Received: from kroah.org ([198.145.64.141]:52892 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab0FRWbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 18:31:53 -0400
Date: Fri, 18 Jun 2010 15:21:48 -0700
From: Greg KH <greg@kroah.com>
To: Bashlykov Arthur <madness@xakep.ru>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: rtl8192su: ieee80211: fix brace coding
 style issue and other issues in ieee80211_softmac_wx.c Signed-off-by:
 Andrea Merello <andreamrl@tiscali.it>
Message-ID: <20100618222148.GA12538@kroah.com>
References: <1274949494-3660-1-git-send-email-madness@xakep.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274949494-3660-1-git-send-email-madness@xakep.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 12:38:14PM +0400, Bashlykov Arthur wrote:
> ---
>  .../rtl8192su/ieee80211/ieee80211_softmac_wx.c     |  149 +++++++++-----------
>  1 files changed, 70 insertions(+), 79 deletions(-)

This patch breaks the build, did you try to test this code out?

Can you test building these patches and then resend them after you have
determined that they work properly?

thanks,

greg k-h
