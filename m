Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab0LPQOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:14:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:30485 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab0LPQOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:14:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,355,1288594800"; 
   d="scan'208";a="687825233"
Subject: Re: [PATCH] iwlwifi: Fix error: struct iwl_lq_sta has no member
 named dbg_fixed_rate
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        John Linville <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <AANLkTink67RM4mp537UxFcx4g-9Dx+ymbW0A=cCu3C4g@mail.gmail.com>
References: <AANLkTink67RM4mp537UxFcx4g-9Dx+ymbW0A=cCu3C4g@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 16 Dec 2010 08:13:35 -0800
Message-Id: <1292516015.27593.26.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sedat,

On Thu, 2010-12-16 at 03:46 -0800, Sedat Dilek wrote:
> Attached patch fixes an issue with linux-next (20101216) and iwlwifi (see [1]).
> 
> - Sedat -
> 
> [1] http://lkml.org/lkml/2010/12/16/101

ACKed-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Thank you very much for catch this mistake and fix it so quickly.

Wey

