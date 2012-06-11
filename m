Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab2FKHZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 03:25:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40939 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2FKHZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 03:25:33 -0400
Date: Mon, 11 Jun 2012 10:25:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: ipack: remove pr_fmt definition.
Message-ID: <20120611072500.GT4400@mwanda>
References: <1339397797-17399-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339397797-17399-1-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 08:56:36AM +0200, Samuel Iglesias Gonsalvez wrote:
> As there is no pr_* function used here, pr_fmt is not needed.
> 

Nah.  What about if we decide to add some?  Also there are actually
a couple pr_err() calls in there already.

regards,
dan carpenter

