Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab1LTRdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 12:33:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:37548 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab1LTRdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 12:33:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="89606752"
Date: Tue, 20 Dec 2011 18:37:57 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@st.com>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20111220173757.GC5183@sortiz-mobl>
References: <20111220141731.04efb8c1b002e3a313076378@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220141731.04efb8c1b002e3a313076378@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Dec 20, 2011 at 02:17:31PM +1100, Stephen Rothwell wrote:
> Hi Samuel,
> 
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/built-in.o: In function `i2c_block_write':
> stmpe-i2c.c:(.text+0xf4553): undefined reference to `i2c_smbus_write_i2c_block_data'
> drivers/built-in.o: In function `i2c_block_read':
> stmpe-i2c.c:(.text+0xf457f): undefined reference to `i2c_smbus_read_i2c_block_data'
> drivers/built-in.o: In function `i2c_reg_write':
> stmpe-i2c.c:(.text+0xf45ab): undefined reference to `i2c_smbus_write_byte_data'
> drivers/built-in.o: In function `i2c_reg_read':
> stmpe-i2c.c:(.text+0xf45d4): undefined reference to `i2c_smbus_read_byte_data'
> drivers/built-in.o: In function `stmpe_init':
> stmpe-i2c.c:(.init.text+0xaf22): undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `stmpe_exit':
> stmpe-i2c.c:(.exit.text+0x5e5): undefined reference to `i2c_del_driver'
> 
> Caused by commit b25a31a3b4d3 ("mfd: Separate out STMPE controller and
> interface specific code").
> 
> I have used the mfd tree from next-20111219 for today.
Thanks for the notification. This should be all fixed now, you can use the
latest MFD tree.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
