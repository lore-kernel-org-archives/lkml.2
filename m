Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab0CRQLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 12:11:07 -0400
Received: from mail0.scram.de ([78.47.204.202]:48780 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab0CRQLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 12:11:04 -0400
X-Greylist: delayed 744 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Mar 2010 12:11:04 EDT
Authentication-Results: localhost; dkim=pass (1024-bit key)
	header.i=@scram.de; dkim-asp=signed
X-Spam-Flag: NO
X-Spam-Score: -3.904
Authentication-Results: amavis.colab.de (amavisd-new); dkim=pass
	header.i=@scram.de
Message-ID: <4BA24DA8.9030309@scram.de>
Date: Thu, 18 Mar 2010 16:58:32 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: davem@davemloft.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Subject: Re: [V2 PATCH 06/10] of/drivers: Always use struct device.of_node
 to get	node pointer
References: <20100318144836.21082.93040.stgit@angua> <20100318152238.21082.10985.stgit@angua>
In-Reply-To: <20100318152238.21082.10985.stgit@angua>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

> The following structure elements duplicate the information in
> 'struct device.of_node' and so are being eliminated.  This patches
> makes all readers of the following elements use device.of_node instead.
> 
> struct dev_archdata.prom_node (sparc)
> struct dev_archdata.of_node (powerpc)
> struct of_device.node
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
>  drivers/i2c/busses/i2c-ibm_iic.c              |    4 ++--
>  drivers/i2c/busses/i2c-mpc.c                  |   17 ++++++++-------

drivers/i2c/busses/i2c-cpm.c is missing in this patch.

Thanks,
Jochen
