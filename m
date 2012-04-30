Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab2D3T24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 15:28:56 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32601 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab2D3T2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 15:28:54 -0400
Date: Mon, 30 Apr 2012 22:31:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: joseph daniel <josephdanielwalter@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi/mvsas: Remove an unused variable
Message-ID: <20120430193136.GL6447@mwanda>
References: <1335813846-8042-1-git-send-email-josephdanielwalter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335813846-8042-1-git-send-email-josephdanielwalter@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 01:24:05AM +0600, joseph daniel wrote:
> the pointer of type struct domain_device is not used anywhere in the code.
> 

This is already fixed in linux-next.

regards,
dan carpenter

