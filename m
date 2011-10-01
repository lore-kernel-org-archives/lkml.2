Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab1JAPMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 11:12:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19449 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1JAPMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 11:12:32 -0400
Date: Sat, 1 Oct 2011 18:09:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] Staging: comedi: fix printk issue in cb_pcidas.c
Message-ID: <20111001150942.GD3901@longonot.mountain>
References: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
 <1317388707-1980-3-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317388707-1980-3-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4E872DDB.00E4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 06:48:21PM +0530, Ravishankar Karkala Mallikarjunayya wrote:
>  	if (comedi_pci_enable(pcidev, "cb_pcidas")) {
> -		printk(" Failed to enable PCI device and request regions\n");
> +		dev_err(&pcidev->dev, " Failed to enable PCI "
                                       ^
This space isn't needed any more now that it's at the start of a
line.

> +			"device and request regions\n");
>  		return -EIO;

I'm not going to review the remaining 6 patches.

regards,
dan carpenter

