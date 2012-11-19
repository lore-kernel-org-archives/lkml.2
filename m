Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab2KSLQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 06:16:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24052 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab2KSLQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 06:16:24 -0500
Date: Mon, 19 Nov 2012 14:15:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kumar Amit Mehta <gmate.amit@gmail.com>
Cc: gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk, wfp5p@virginia.edu,
        geert@linux-m68k.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] staging: dgrp: dgrp_tty.c: Audit the return values of
 get/put_user()
Message-ID: <20121119111553.GC6186@mwanda>
References: <1353322531-10092-1-git-send-email-gmate.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353322531-10092-1-git-send-email-gmate.amit@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 04:25:31PM +0530, Kumar Amit Mehta wrote:
> -- fix for missing audits for return values of get_user() and put_user().
> -- Remove the TIOCSSOFTCAR ioctl handling from dgrp driver.

These should be done in separate commits.

Are the calls to access_ok() still needed if we check get_user() and
put_user()?

regards,
dan carpenter

