Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab1DVQxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:53:07 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:59569 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756254Ab1DVQxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:53:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LspiWLT23QcmWxcFEuYcuocjsw8WxTtCaHwp2+vkcwl78mbTiFL+q3o8r4t1rRy1ipl8jESHoVNmcqDR2Ynv8NjTi+jfCxhqK+GB0ReH4u4rdMVilxT+UPZTmm2umAOx;
Date: Fri, 22 Apr 2011 09:52:59 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Seth Heasley <seth.heasley@intel.com>, linux-i2c@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.39-rc3] i2c-i801: SMBus patch for Intel Panther
 Point DeviceIDs
Message-ID: <20110422095259.4d5875d2@jbarnes-desktop>
In-Reply-To: <20110422184449.06116327@endymion.delvare>
References: <201104201133.39979.seth.heasley@intel.com>
	<20110422184449.06116327@endymion.delvare>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Apr 2011 18:44:49 +0200
Jean Delvare <khali@linux-fr.org> wrote:

> Hi Seth,
> 
> On Wed, 20 Apr 2011 11:33:39 -0700, Seth Heasley wrote:
> > This patch adds the SMBus controller DeviceID for the Intel Panther Point PCH.
> 
> With each new chip, we have to add the SMBus device ID to pci_ids.h,
> then wait for Jesse to merge that, and only then I can apply the
> changes to i2c-i801.c. This approach slows things down needlessly.
> 
> It isn't mandatory to add IDs to pci_ids.h when an ID is only used
> locally in a device driver. So what I would like to propose is that we
> move all PCI_DEVICE_ID_INTEL_*_SMBUS declarations from pci_ids.h to
> i2c-i801.c now. Then you can resubmit your Panther Point patches, and
> the pci and i2c parts will be independent, so Jesse and myself don't
> depend on each other to apply them.
> 
> What do you think? Jesse, any objection?
> 
> Seth, if you agree, I can take care of the move, or you can send a
> patch doing that, whatever you prefer.

Yeah, that makes sense.  I'd be happy to take a patch to pull the
defines out of pci_ids.h and push them into the x86 irq.c and your i2c
code.

-- 
Jesse Barnes, Intel Open Source Technology Center
