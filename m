Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2JVVEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:04:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65114 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab2JVVD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:03:59 -0400
Date: Mon, 22 Oct 2012 14:03:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sangho Yi <antiroot@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: CSR: Fixed 41% of exceeding 80 characters
 problems on drv.c
Message-ID: <20121022210355.GA23826@kroah.com>
References: <n>
 <1350230306-32515-1-git-send-email-antiroot@gmail.com>
 <1350230306-32515-2-git-send-email-antiroot@gmail.com>
 <20121018133638.GP5685@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018133638.GP5685@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 04:36:38PM +0300, Dan Carpenter wrote:
> On Mon, Oct 15, 2012 at 12:58:26AM +0900, Sangho Yi wrote:
> > -int buswidth = 0;			   /* 0 means use default, values 1,4 */
> > -int sdio_clock = 50000;		 /* kHz */
> > +int buswidth = 0;		/* 0 means use default, values 1,4 */
> > +int sdio_clock = 50000;		/* kHz */
> 
> These are nonsense indenting.  :(

I agree.  Sangho, please be smart about your cleanups, these two are not
acceptable, so I'm dropping them from my queue.

greg k-h
