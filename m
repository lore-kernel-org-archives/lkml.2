Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab0JSRGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:06:44 -0400
Received: from kroah.org ([198.145.64.141]:41052 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522Ab0JSRGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:06:42 -0400
Date: Tue, 19 Oct 2010 10:03:42 -0700
From: Greg KH <greg@kroah.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/3] staging: batman-adv: remove useless
 addr_to_string()
Message-ID: <20101019170342.GA18575@kroah.com>
References: <11c47095d961ba40ad95ecf995094e78e4d96fdf.1287223789.git.andy.shevchenko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <11c47095d961ba40ad95ecf995094e78e4d96fdf.1287223789.git.andy.shevchenko@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 01:11:10PM +0300, Andy Shevchenko wrote:
> Since all *printf() methods in the kernel understand '%pM' modifier the
> conversion to the string is useless beforehand.
> 
> Additionally this patch decreases batman_if structure by 20 bytes.

And also, it breaks the build:
	drivers/staging/batman-adv/vis.c: In function ‘vis_data_read_entry’:
	drivers/staging/batman-adv/vis.c:170:38: error: ‘to’ undeclared (first use in this function)
	drivers/staging/batman-adv/vis.c:170:38: note: each undeclared identifier is reported only once for each function it appears in

Please always test your patches :(

I've dropped this one.

thanks,

greg k-h
