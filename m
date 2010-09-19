Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab0ISW1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 18:27:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:20002 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab0ISW1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 18:27:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,390,1280732400"; 
   d="scan'208";a="658921480"
Date: Mon, 20 Sep 2010 00:27:48 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gary King <gking@nvidia.com>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20100919222747.GA4235@sortiz-mobl>
References: <20100916125447.08698025.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916125447.08698025.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Sep 16, 2010 at 12:54:47PM +1000, Stephen Rothwell wrote:
> Hi Samuel,
> 
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/built-in.o: In function `__tps6586x_read':
> tps6586x.c:(.text+0xe4151): undefined reference to `i2c_smbus_read_byte_data'
> drivers/built-in.o: In function `__tps6586x_write':
> tps6586x.c:(.text+0xe4345): undefined reference to `i2c_smbus_write_byte_data'
> drivers/built-in.o: In function `tps6586x_reads':
> (.text+0xe4762): undefined reference to `i2c_smbus_read_i2c_block_data'
> drivers/built-in.o: In function `tps6586x_writes':
> (.text+0xe4894): undefined reference to `i2c_smbus_write_i2c_block_data'
> drivers/built-in.o: In function `tps6586x_init':
> tps6586x.c:(.init.text+0xc511): undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `tps6586x_i2c_probe':
> tps6586x.c:(.devinit.text+0x4ae6): undefined reference to `i2c_smbus_read_byte_data'
> drivers/built-in.o: In function `tps6586x_exit':
> tps6586x.c:(.exit.text+0x574): undefined reference to `i2c_del_driver'
> 
> Caused by commit 2d0a9a6d922712267ef62a5e8b38ed2b37cf45cc ("mfd: Add
> basic tps6586x interrupt support").  Presumably a missing dependency.
> 
> I have used the mfd tree from next-20100915 for today.
Sorry about that, this is fixed now.

Cheers,
Samuel.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/



-- 
Intel Open Source Technology Centre
http://oss.intel.com/
