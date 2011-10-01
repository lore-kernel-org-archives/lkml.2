Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab1JAPIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 11:08:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:60986 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab1JAPIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 11:08:24 -0400
Date: Sat, 1 Oct 2011 18:05:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] Staging: comedi: fix printk issue in cb_pcidda.c
Message-ID: <20111001150532.GC3901@longonot.mountain>
References: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
 <1317388707-1980-2-git-send-email-ravishankar.km@greenturtles.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317388707-1980-2-git-send-email-ravishankar.km@greenturtles.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090209.4E872CE1.0028,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 06:48:20PM +0530, Ravishankar Karkala Mallikarjunayya wrote:
> @@ -377,12 +379,8 @@ found:
>  	s = dev->subdevices + 2;
>  	subdev_8255_init(dev, s, NULL, devpriv->digitalio + PORT2A);
>  
> -	printk(" eeprom:");
> -	for (index = 0; index < EEPROM_SIZE; index++) {
> +	for (index = 0; index < EEPROM_SIZE; index++)
>  		devpriv->eeprom_data[index] = cb_pcidda_read_eeprom(dev, index);
> -		printk(" %i:0x%x ", index, devpriv->eeprom_data[index]);
> -	}
> -	printk("\n");
>  

This wasn't mentioned in the change log.

regards,
dan carpenter

