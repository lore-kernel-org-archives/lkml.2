Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab1ANEld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 23:41:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691Ab1ANEl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 23:41:26 -0500
Date: Thu, 13 Jan 2011 20:36:19 -0800
From: Greg KH <gregkh@suse.de>
To: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: your mail
Message-ID: <20110114043619.GA5770@suse.de>
References: <1294967693-1938-1-git-send-email-omar.ramirez@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294967693-1938-1-git-send-email-omar.ramirez@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 07:14:53PM -0600, Omar Ramirez Luna wrote:
> Please pull these changes for 2.6.38:
> 
> The following changes since commit 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5:
> 
>   Linux 2.6.37 (2011-01-04 16:50:19 -0800)
> 
> are available in the git repository at:
>   git://dev.omapzoom.org/pub/scm/tidspbridge/kernel-dspbridge.git for-gkh-2.6.38
> 
> Guzman Lugo, Fernando (1):
>       staging: tidspbridge: configure full L1 MMU range
> 
> Omar Ramirez Luna (1):
>       staging: tidspbridge: replace mbox callback with notifier_call
> 
>  drivers/staging/tidspbridge/core/tiomap3430.c |   15 +++++++--------
>  1 files changed, 7 insertions(+), 8 deletions(-)

You forgot a Subject: line.

Also, as these are just 2 patches, care to just email them so we can
review them?

thanks,

greg k-h
