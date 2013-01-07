Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab3AGXCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 18:02:23 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53296 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab3AGXCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 18:02:22 -0500
Date: Mon, 7 Jan 2013 15:02:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Johannes Berg <johannes.berg@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wlan-ng: Update get_tx_power()/set_tx_power()
 signature
Message-ID: <20130107230217.GA29832@kroah.com>
References: <1355660922-12833-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355660922-12833-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 01:28:42PM +0100, Geert Uytterhoeven wrote:
> In file included from drivers/staging/wlan-ng/p80211netdev.c:92:
> drivers/staging/wlan-ng/cfg80211.c:735: warning: initialization from incompatible pointer type
> drivers/staging/wlan-ng/cfg80211.c:736: warning: initialization from incompatible pointer type
> 
> Cfr. commit c8442118ad9cd05cfe3b993f058e70ab25b1009a ("cfg80211: allow per
> interface TX power setting"), which added a new parameter.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/staging/wlan-ng/cfg80211.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)

Sorry, someone else already sent this in, and it's now in my tree.

thanks,

greg k-h
