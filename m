Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0LARrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:47:03 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33615 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab0LARrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:47:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CJPXgVPOOm+PyddVFTWGHZ2xIOE0cD28q8hpi7VluwNPoKZoMQyS77GFlTuREIdQBl
         EpcPWEWqPTH2MMNBd0LZviRCgeYqtLOFo6IJUuAy/vWYxqGQL6vV0J1VBNL4w6wSAwnH
         ReX4hODzO0vHVWltbEkHvBi8jEMxyabsKD+2o=
Subject: Re: edac_core: crashes on shutdown
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101201143329.GB18074@a1.tnic>
References: <1291201307.3029.21.camel@Tobias-Karnat>
	 <20101201123921.GA15530@a1.tnic> <1291209888.12511.11.camel@Tobias-Karnat>
	 <20101201143329.GB18074@a1.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 18:46:54 +0100
Message-ID: <1291225614.8646.4.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 01.12.2010, 15:33 +0100 schrieb Borislav Petkov:
> Unfortunately, this is still incomplete because it is missing the Code: tag and
> the end trace tag which looks like this
> 
> ---[ end trace ... ]---
> 
> and this is most probably so because we're halting and cannot print out
> all the oops. Two things you can do:
> 
> 1. Connect the machine to another machine over serial- or netconsole.
> Google for instructions how.
> 
> 2. If you can't do 1. you can try enabling CONFIG_BOOT_PRINTK_DELAY and
> boot the kernel with 'boot_delay=10', for example, so that a 10ms delay
> is inserted after each printk line. This might let us see more on the
> console before halt and catch the whole oops.
> 
> Thanks.

Yes, boot_delay=10 has helped and I also removed the nvidia driver:

http://oi56.tinypic.com/eas0pg.jpg

-Tobias



