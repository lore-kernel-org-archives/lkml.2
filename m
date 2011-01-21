Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1AUAIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 19:08:47 -0500
Received: from kroah.org ([198.145.64.141]:56114 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab1AUAIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 19:08:46 -0500
Date: Thu, 20 Jan 2011 16:07:35 -0800
From: Greg KH <greg@kroah.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 4/4] Staging: zram: simplify zram_make_request
Message-ID: <20110121000735.GA21027@kroah.com>
References: <4D0B88E5.4040005@redhat.com>
 <4D0B89F7.1000103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0B89F7.1000103@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 05:04:07PM +0100, Jerome Marchand wrote:
> 
> zram_read() and zram_write() always return zero, so make them return
> void to simplify the code.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>  zram_drv.c |   19 ++++++++-----------

This doesn't apply anymore, care to redo it and resend?

thanks,

greg k-h
