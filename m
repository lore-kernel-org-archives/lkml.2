Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab2FKH2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 03:28:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34083 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab2FKH2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 03:28:09 -0400
Date: Mon, 11 Jun 2012 10:27:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: ipack: remove pr_fmt definition.
Message-ID: <20120611072736.GI13539@mwanda>
References: <1339397797-17399-1-git-send-email-siglesias@igalia.com>
 <20120611072500.GT4400@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120611072500.GT4400@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 10:25:00AM +0300, Dan Carpenter wrote:
> On Mon, Jun 11, 2012 at 08:56:36AM +0200, Samuel Iglesias Gonsalvez wrote:
> > As there is no pr_* function used here, pr_fmt is not needed.
> > 
> 
> Nah.  What about if we decide to add some?  Also there are actually
> a couple pr_err() calls in there already.

Oops.  Sorry my tree is old.  We removed the two calls to pr_err().

regards,
dan carpenter
