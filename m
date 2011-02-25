Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab1BYUfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:35:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:65364 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925Ab1BYUfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:35:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,227,1297065600"; 
   d="scan'208";a="713377918"
Subject: Re: linux-next: build failure after merge of the final tree
 (wireless tree related)
From: wwguy <wey-yi.w.guy@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
In-Reply-To: <20110225171625.60e967f8.sfr@canb.auug.org.au>
References: <20110225171625.60e967f8.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 12:33:43 -0800
Message-ID: <1298666023.2603.15.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, 2011-02-24 at 22:16 -0800, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/net/wireless/iwlegacy/built-in.o:(.rodata+0x29f0): multiple definition of `iwl_rates'
> drivers/net/wireless/iwlwifi/built-in.o:(.rodata+0xa68): first defined here
> powerpc64-linux-ld: Warning: size of symbol `iwl_rates' changed from 143 in drivers/net/wireless/iwlwifi/built-in.o to 130 in drivers/net/wireless/iwlegacy/built-in.o
> drivers/net/wireless/iwlegacy/built-in.o:(.data+0x0): multiple definition of `bt_coex_active'
> drivers/net/wireless/iwlwifi/built-in.o:(.data+0x668): first defined here
> drivers/net/wireless/iwlegacy/built-in.o:(.rodata+0x750): multiple definition of `iwl_eeprom_band_1'
> drivers/net/wireless/iwlwifi/built-in.o:(.rodata+0x27d0): first defined here
> drivers/net/wireless/iwlegacy/built-in.o:(.rodata+0x3f0): multiple definition of `iwl_bcast_addr'
> drivers/net/wireless/iwlwifi/built-in.o:(.rodata+0x24f8): first defined here
> drivers/net/wireless/iwlegacy/built-in.o:(.bss+0x3d48): multiple definition of `iwl_debug_level'
> drivers/net/wireless/iwlwifi/built-in.o:(.bss+0x21950): first defined here
> 
> Presumably caused by commit be663ab67077fac8e23eb8e231a8c1c94cb32e54
> ("iwlwifi: split the drivers for agn and legacy devices 3945/4965").
> 
> I have just left this one as it will only break strange configs (like
> allyesconfig) but it needs to be fixed soon.

Thanks for let us know, we will submit separated patch to fix it asap

Wey


