Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab2CTMcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 08:32:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:10794 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672Ab2CTMch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 08:32:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141837529"
Date: Tue, 20 Mar 2012 13:40:41 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20120320124041.GB21753@sortiz-mobl>
References: <20120319131345.a2f5b9983538d25c2974d344@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319131345.a2f5b9983538d25c2974d344@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Mar 19, 2012 at 01:13:45PM +1100, Stephen Rothwell wrote:
> Hi Samuel,
> 
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/built-in.o: In function `rc5t583_i2c_init':
> rc5t583.c:(.init.text+0xb3db): undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `rc5t583_i2c_probe':
> rc5t583.c:(.devinit.text+0x8fa0): undefined reference to `regmap_init_i2c'
> drivers/built-in.o: In function `rc5t583_i2c_exit':
> rc5t583.c:(.exit.text+0x708): undefined reference to `i2c_del_driver'
> 
> Caused by commit 1b1247dd75aa ("mfd: Add support for RICOH PMIC
> RC5T583"). Presumably some missing Kconfig dependency.
> 
> I have ued the version of the mfd tree from next-20120316 for today.
This should be fixed now, thanks for the heads up.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
