Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab2KSNIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 08:08:42 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65279 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2KSNIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 08:08:40 -0500
Date: Mon, 19 Nov 2012 18:38:29 +0530
From: Kumar amit mehta <gmate.amit@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk, wfp5p@virginia.edu,
        geert@linux-m68k.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: dgrp: dgrp_tty.c: Audit the return values of
 get/put_user()
Message-ID: <20121119130829.GB3275@gmail.com>
References: <1353322531-10092-1-git-send-email-gmate.amit@gmail.com>
 <20121119111553.GC6186@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121119111553.GC6186@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 02:15:54PM +0300, Dan Carpenter wrote:
> On Mon, Nov 19, 2012 at 04:25:31PM +0530, Kumar Amit Mehta wrote:
> > -- fix for missing audits for return values of get_user() and put_user().
> > -- Remove the TIOCSSOFTCAR ioctl handling from dgrp driver.
> 
> These should be done in separate commits.
> 
> Are the calls to access_ok() still needed if we check get_user() and
> put_user()?
>
You are right, access_ok() would become redundant if we check get/put_user().
Also, After sending one patch for removing TIOCSSOFTCAR ioctl handler from dgrp
driver, I realized that I should be sending two patches as patch series. Please
correct me if I'm wrong.

Regards,
Amit
