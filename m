Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab1LMX1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 18:27:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:8630 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab1LMX1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 18:27:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="86245080"
Subject: Re: iwlagn regression in v3.1.5
From: wwguy <wey-yi.w.guy@intel.com>
To: Udo Steinberg <udo@hypervisor.org>
Cc: Andrej Gelenberg <andrej.gelenberg@udo.edu>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20111213230443.2c12caeb@x220.fritz.box>
References: <4EE4AEF4.2080702@udo.edu>	<4EE4DB55.4090804@udo.edu>
	 <20111211174138.79e51fe8@x220.fritz.box>	<4EE4E152.2070204@udo.edu>
	 <1323627815.1806.19.camel@wwguy-ubuntu>	<4EE50266.4050208@udo.edu>
	 <1323653737.1806.21.camel@wwguy-ubuntu>	<4EE636B9.1020305@udo.edu>
	 <1323807327.7144.6.camel@wwguy-ubuntu>	<4EE7BEC1.1060506@udo.edu>
	 <20111213230443.2c12caeb@x220.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Dec 2011 15:20:17 -0800
Message-ID: <1323818417.21617.0.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 14:04 -0800, Udo Steinberg wrote:
> Hi,
> 
> Glad to hear it works for you now. In the patch, the following piece of code
> 
> +				if ((iwl_is_associated_ctx(ctx) &&
> +						!ctx->ht.is_40mhz) ||
> +						!iwl_is_associated_ctx(ctx))
> 
> can be simplified to:
> 
> 	if (!iwl_is_associated_ctx(ctx) || !ctx->ht.is_40mhz)
> 
right, looks better this way :-)

Thanks
Wey

