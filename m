Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab1GFSeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:34:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:65294 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab1GFSeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:34:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,488,1304319600"; 
   d="scan'208";a="23400183"
Date: Wed, 6 Jul 2011 20:34:29 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: Don't leak init_data in tps65910_i2c_probe
Message-ID: <20110706183429.GL3021@sortiz-mobl>
References: <alpine.LNX.2.00.1107022120171.16316@swampdragon.chaosbits.net>
 <20110704173320.GR3021@sortiz-mobl>
 <alpine.LNX.2.00.1107050945330.27127@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1107060027280.9158@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107060027280.9158@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

On Wed, Jul 06, 2011 at 12:29:07AM +0200, Jesper Juhl wrote:
> On Tue, 5 Jul 2011, Jesper Juhl wrote:
> 
> > On Mon, 4 Jul 2011, Samuel Ortiz wrote:
> > 
> [...]
> > > This is not a memory leak fix. And I actually prefer the == NULL check.
> > > Please remove the == NULL check replacement with !* and keep only the memory
> > > leak fixing part.
> > > 
> Here's an updated patch.
Applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
