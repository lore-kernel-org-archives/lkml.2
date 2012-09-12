Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab2ILXqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:46:32 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39183 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab2ILXqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:46:24 -0400
Date: Wed, 12 Sep 2012 16:46:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/85] 3.4.11-stable review
Message-ID: <20120912234620.GB23907@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 04:35:43PM -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 3.4.11 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Sep 14 23:35:39 UTC 2012.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.11-rc1.gz
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Shortlog of commits:
> 
> Patch Name                                                  	Original Commit ID	Author
> USB: vt6656: remove __devinit* from the struct usb_device_id	4d088876f24887cd15a2	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> USB: emi62: remove __devinit* from the struct usb_device_id 	83957df21dd94655d2b0	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ALSA: hda - fix Copyright debug message                     	088c820b732dbfd515fc	Wang Xingchao <xingchao.wang@intel.com>
> ARM: 7483/1: vfp: only advertise VFPv4 in hwcaps if CONFIG_V	3d9fb0038a9b02febb01	Will Deacon <will.deacon@arm.com>
> ARM: 7487/1: mm: avoid setting nG bit for user mappings that	47f1204329237a0f8655	Will Deacon <will.deacon@arm.com>
> ARM: 7488/1: mm: use 5 bits for swapfile type encoding      	f5f2025ef3e2cdb59370	Will Deacon <will.deacon@arm.com>
> ARM: 7489/1: errata: fix workaround for erratum #720789 on U	730a8128cd8978467eb1	Will Deacon <will.deacon@arm.com>
> ARM: OMAP2+: Fix dmtimer set source clock failure           	54f32a35f4d3a653a18a	Jon Hunter <jon-hunter@ti.com>
> ARM: S3C24XX: Add missing DMACH_DT_PROP                     	e1267371eacf2cbcf580	Heiko Stuebner <heiko@sntech.de>
> ARM: S3C24XX: Fix s3c2410_dma_enqueue parameters            	b01858c7806e7e6f6121	Heiko Stuebner <heiko@sntech.de>
> Revert dma: imx-dma: Fix kernel crash due to missing clock c	upstream.	Fabio Estevam <festevam@gmail.com>

And my script broke here, for a patch that was not upstream, but was a
revert, which I guess shows it is working somehow...  I'll work on it
some more for the nextime this happens.

greg k-h
