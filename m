Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab0D0SCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:02:40 -0400
Received: from kroah.org ([198.145.64.141]:36607 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab0D0R7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:59:38 -0400
Date: Tue, 27 Apr 2010 10:24:08 -0700
From: Greg KH <greg@kroah.com>
To: wouter.vanrooy@gmail.com
Cc: gregkh@suse.de, andre@bitwigglers.org, ak@linux.intel.com,
       peterhuewe@gmx.de, kevin.granade@gmail.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: asus_oled: fix space where tab should be This
 patches the asus_oled.c file so that checkpatch.pl doesn't provide any
 more warnings. Signed-off-by: Wouter Van Rooy <wouter.vanrooy@gmail.com>
Message-ID: <20100427172408.GC28779@kroah.com>
References: <1268254815-11995-1-git-send-email-wouter.vanrooy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268254815-11995-1-git-send-email-wouter.vanrooy@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 10:00:15PM +0100, wouter.vanrooy@gmail.com wrote:
> From: wouter <wouter@wouter-desktop.(none)>
> 
> ---
>  drivers/staging/asus_oled/asus_oled.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Sorry, someone already sent this fix in.

greg k-h
