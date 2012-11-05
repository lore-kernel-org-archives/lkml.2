Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab2KEGsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 01:48:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:56652 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab2KEGsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 01:48:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,713,1344236400"; 
   d="scan'208";a="164524842"
Message-ID: <1352098078.2216.22.camel@rzhang1-mobl4>
Subject: Re: linux-next: manual merge of the thermal tree with Linus' tree
From: Zhang Rui <rui.zhang@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Devendra Naga <develkernel412222@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Durgadoss R <durgadoss.r@intel.com>
Date: Mon, 05 Nov 2012 14:47:58 +0800
In-Reply-To: <20121105114644.fe54cba816860bf12f1de9cf@canb.auug.org.au>
References: <20121105114644.fe54cba816860bf12f1de9cf@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stephen,

On Mon, 2012-11-05 at 11:46 +1100, Stephen Rothwell wrote:
> Hi Zhang,
> 
> Today's linux-next merge of the thermal tree got a conflict in
> drivers/thermal/rcar_thermal.c between commit 608f62b996c6 ("thermal:
> solve compilation errors in rcar_thermal") from Linus' tree and commit
> ebbf0f11e7b4 ("Thermal: Pass zone parameters as argument to
> tzd_register") from the thermal tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
I've rebased my -next branch on top of 3.7-rc4.
so please drop this fix.

thanks,
rui

