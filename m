Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab1AYGMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 01:12:12 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:32849 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab1AYGMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 01:12:10 -0500
Date: Tue, 25 Jan 2011 15:12:03 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Bryan Wu <cooloney@kernel.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] drivers/video/bf537-lq035.c: Add missing IS_ERR test
Message-ID: <20110125061203.GD11673@linux-sh.org>
References: <1295898922-18822-1-git-send-email-julia@diku.dk> <1295898922-18822-4-git-send-email-julia@diku.dk> <201101241543.19543.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101241543.19543.vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 03:43:17PM -0500, Mike Frysinger wrote:
> On Monday, January 24, 2011 14:55:21 Julia Lawall wrote:
> > lcd_device_register may return ERR_PTR, so a check is added for this value
> > before the dereference.  All of the other changes reorganize the error
> > handling code in this function to avoid duplicating all of it in the added
> > case.
> > 
> > In the original code, in one case, the global variable fb_buffer was set to
> > NULL in error code that appears after this variable is initialized.  This
> > is done now in all error handling code that has this property.
> 
> Acked-by: Mike Frysinger <vapier@gentoo.org>

Applied, thanks.
