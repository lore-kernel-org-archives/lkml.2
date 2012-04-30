Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab2D3UQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:16:45 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39035 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab2D3UQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:16:10 -0400
Date: Mon, 30 Apr 2012 23:18:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: joseph daniel <josephdanielwalter@gmail.com>
Cc: devel@driverdev.osuosl.org, Lars-Peter Clausen <lars@metafoo.de>,
        linux-iio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] staging/iio/meter: fix the coding style problem
Message-ID: <20120430201855.GN6447@mwanda>
References: <1335813977-8096-1-git-send-email-josephdanielwalter@gmail.com>
 <20120430200444.GM6447@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120430200444.GM6447@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 11:04:44PM +0300, Dan Carpenter wrote:
> On Tue, May 01, 2012 at 01:26:17AM +0600, joseph daniel wrote:
> > 
> > Signed-off-by: joseph daniel <josephdanielwalter@gmail.com>
> > ---
> > Hi Lars,
> > 	Thanks for review. how about the below change?

Lar's review is the correct one.  It's cleaner to use
get_unaligned_be32().  You'll need to include <asm/unaligned.h>

regards,
dan carpenter

