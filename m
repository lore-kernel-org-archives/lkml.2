Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab0DNRBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 13:01:54 -0400
Received: from kroah.org ([198.145.64.141]:56328 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113Ab0DNRBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 13:01:53 -0400
Date: Wed, 14 Apr 2010 10:01:53 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       Alan Cox <alan@linux.intel.com>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: isl29020: ALS driver as misc device
Message-ID: <20100414170153.GA7494@kroah.com>
References: <20100414124913.23181.75903.stgit@localhost.localdomain> <20100414125136.23181.16788.stgit@localhost.localdomain> <4BC5C7A8.1040807@cam.ac.uk> <20100414153234.22765666@lxorguk.ukuu.org.uk> <4BC5D681.20707@jic23.retrosnub.co.uk> <20100414175602.44580f3c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414175602.44580f3c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 05:56:02PM +0100, Alan Cox wrote:
> And this adds the isl29020 as a misc device per discussions
> 
> isl29020: ambient light sensor
> 
> From: Kalhan Trisal <kalhan.trisal@intel.com>
> 
> The LS driver will read the latest Lux measurement based upon the
> light brightness and will report the LUX output through sysfs interface.

Please document this sysfs interface with an addition to the
Documentatin/ABI/ directory.

thanks,

greg k-h
