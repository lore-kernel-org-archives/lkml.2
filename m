Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab0D0R7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 13:59:36 -0400
Received: from kroah.org ([198.145.64.141]:36574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab0D0R7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:59:35 -0400
Date: Tue, 27 Apr 2010 10:23:01 -0700
From: Greg KH <greg@kroah.com>
To: Mike Sheldon <mike@mikeasoft.com>
Cc: gregkh@suse.de, andre@bitwigglers.org, ak@linux.intel.com,
       peterhuewe@gmx.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: asus_oled: Remove space character mixed in
 with tab indentation. This patches asus_oled.c to remove a space character
 in the middle of some tab indentation (found by checkpatch.pl).
 Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
Message-ID: <20100427172301.GC13053@kroah.com>
References: <1268181455-20437-1-git-send-email-mike@mikeasoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268181455-20437-1-git-send-email-mike@mikeasoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 12:37:35AM +0000, Mike Sheldon wrote:
> ---
>  drivers/staging/asus_oled/asus_oled.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Sorry, someone else already sent this fix in.

greg k-h
