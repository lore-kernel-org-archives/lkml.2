Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab0IEHjn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 03:39:43 -0400
Received: from kroah.org ([198.145.64.141]:41257 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab0IEHjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 03:39:42 -0400
Date: Sun, 5 Sep 2010 00:34:52 -0700
From: Greg KH <greg@kroah.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
        Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Huang Weiyi <weiyi.huang@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] staging: xgifb: Init uninitialized variables and
	fix some style issues
Message-ID: <20100905073452.GA15932@kroah.com>
References: <1283641765.9641.7.camel@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283641765.9641.7.camel@lenovo>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 04, 2010 at 07:09:25PM -0400, Javier Martinez Canillas wrote:
> 
> Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
> ---
>  drivers/staging/xgifb/vb_setmode.c |   35 +++++++++++++++++------------------

Sorry, this no longer applies due to some coding style cleanups in this
file done by someone else earlier today.

Can you redo this against the next linux-next tree and send me the new
version?

thanks,

greg k-h
