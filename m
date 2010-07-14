Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab0GNUy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:54:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:40665 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757496Ab0GNUyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:54:55 -0400
Date: Wed, 14 Jul 2010 13:36:26 -0700
From: Greg KH <gregkh@suse.de>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Alexander Kurz <linux@kbdbabel.org>, Jiri Kosina <jkosina@suse.cz>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] staging: msm: formatting of pointers in printk()
Message-ID: <20100714203626.GA29243@suse.de>
References: <1279130717-15755-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279130717-15755-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 10:05:17PM +0400, Kulikov Vasiliy wrote:
> Use %p instead of %08x in printk().
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/staging/comedi/drivers/quatech_daqp_cs.c |    2 +-

Why does your Subject: say "msm"?

greg k-h
