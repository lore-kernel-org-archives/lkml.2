Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab0FBT52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:57:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932897Ab0FBT50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:57:26 -0400
Date: Wed, 2 Jun 2010 11:53:23 -0700
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: devel <devel@driverdev.osuosl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/staging/batman-adv: Convert MAC_FMT to %pM
Message-ID: <20100602185323.GA6600@suse.de>
References: <1275498615.23599.12.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275498615.23599.12.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 10:10:15AM -0700, Joe Perches wrote:
> Remove the last uses of MAC_FMT
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/staging/batman-adv/main.c              |    3 +-
>  drivers/staging/batman-adv/translation-table.c |   25 ++++-------------------

The TODO file in this directory clearly states who to copy on patches to
these files.

Please resend them to the people there so that they can sync up with the
other patches they have already sent me.

thanks,

greg k-h
