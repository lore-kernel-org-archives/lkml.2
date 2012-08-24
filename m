Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2HXPGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 11:06:04 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38388 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733Ab2HXPF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 11:05:59 -0400
Date: Fri, 24 Aug 2012 10:05:33 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Peter.Huewe@infineon.com
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, adlai@linux.vnet.ibm.com,
        xiaoyan.zhang@intel.com, jj@chaosbits.net
Subject: Re: [GIT PULL] tpmdd: TPM drivers, tpm-rng and fixes
Message-ID: <20120824150533.GA2190@linux.vnet.ibm.com>
References: <20120822215216.GC13519@linux.vnet.ibm.com>
 <alpine.LRH.2.02.1208240632120.25506@tundra.namei.org>
 <74A44E99E3274B4CB570415926B37D440E13FD@MUCSE501.eu.infineon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74A44E99E3274B4CB570415926B37D440E13FD@MUCSE501.eu.infineon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082415-9360-0000-0000-000009CCB401
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 08:32:47AM +0000, Peter.Huewe@infineon.com wrote:
> >> From: James Morris [mailto:jmorris@namei.org] 
> >> I'm getting this error when building i2c as a module
> >> WARNING: "__i2c_transfer" [drivers/char/tpm/tpm_i2c_infineon.ko] undefined!
> 
> > This is unconditionally (except I2C) available in Linus' master tree.
> > And was introduced by b37d2a3a75cb in June by Jean Delvare.
> 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b37d2a3a75cb0e72e18c29336cb2095b63dabfc8
> 
> > It was tested here against Linus' tree at time of submission.
> 
> Did double check it against v3.6-rc3.
> $ make ARCH=arm omap2plus_defconfig
> $ make ARCH=arm menuconfig
> -> deselected OMAP2_TYPICAL, which enables I2C to be builded as a module.
> -> selected I2C as Module.
> Build using make -> no error.

  I can't reproduce this either, James, can you send out your .config?

THanks,
Kent

> 
> Thanks,
> Peter
> 
> 
> 

