Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab2KEBSB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 20:18:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:22969 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab2KEBSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 20:18:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,712,1344236400"; 
   d="scan'208";a="237136531"
Message-ID: <1352078275.2492.0.camel@rzhang1-mobl4>
Subject: Re: linux-next: manual merge of the thermal tree with Linus' tree
From: Zhang Rui <rui.zhang@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Devendra Naga <develkernel412222@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Durgadoss R <durgadoss.r@intel.com>
Date: Mon, 05 Nov 2012 09:17:55 +0800
In-Reply-To: <20121105114644.fe54cba816860bf12f1de9cf@canb.auug.org.au>
References: <20121105114644.fe54cba816860bf12f1de9cf@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
the fix looks good to me, Thanks!

-rui


