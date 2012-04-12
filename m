Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab2DLHeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 03:34:05 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40638 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab2DLHeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 03:34:03 -0400
Date: Thu, 12 Apr 2012 10:35:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: jic23@cam.ac.uk, gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, jbrenner@taosinc.com, rklein@nvidia.com,
        max@stro.at, linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] staging: iio: add driver for isl29028
Message-ID: <20120412073554.GA6498@mwanda>
References: <1334214492-23044-1-git-send-email-ldewangan@nvidia.com>
 <1334214492-23044-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334214492-23044-2-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F86855D.000B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 12:38:11PM +0530, Laxman Dewangan wrote:
> Intersil's ISL29028 is concurrent Ambient Light and
> Proximity Sensor device.
> Add driver to access the light and IR intensity and
> proximity value via iio interface.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Taken care of all review comment from Dan.

Looks nice.  You went above and beyond and cleaned up a couple
things I didn't mention.  Thanks.

regards,
dan carpenter

