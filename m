Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab2BZVpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 16:45:12 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21243 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2BZVpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 16:45:09 -0500
Date: Sun, 26 Feb 2012 22:43:06 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: "Latif, Faisal" <faisal.latif@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        Roland Dreier <roland@kernel.org>
Subject: RE: [PATCH] IB: Fix potential mem leak in schedule_nes_timer()
In-Reply-To: <1EEBC91386407A4A8D1EBE1DD5AA5212D36E22@FMSMSX105.amr.corp.intel.com>
Message-ID: <alpine.LNX.2.00.1202262242290.6089@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202202153230.20998@swampdragon.chaosbits.net> <1EEBC91386407A4A8D1EBE1DD5AA5212D36E22@FMSMSX105.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012, Latif, Faisal wrote:

> I do not approve this patch. 
> 
> The type field is always set to either NES_TIMER_TYPE_SEND or 
> NES_TIMER_TYPE_CLOSE when schedule_nes_timer() is called. Even if we 
> wanted to make sure the value of type is one or the other, proper patch 
> can be just a if stmt to check the type before new_send allocation.
> 
Makes sense. I'll drop the patch for now.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

