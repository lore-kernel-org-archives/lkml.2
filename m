Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab0DICSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 22:18:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:60672 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab0DICSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 22:18:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,174,1270450800"; 
   d="scan'208";a="263708080"
Subject: Re: [REVERT] be6b38bcb175613f239e0b302607db346472c6b6.
 v2.6.34-rc3-406 oops with 4965AGN wireless
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: "Zhao, Shanyu" <shanyu.zhao@intel.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "stable@kernel.org" <stable@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <k2yb6a2187b1004081736td3a4c0f3uc05451902bec39a5@mail.gmail.com>
References: <Pine.LNX.4.64.1004090251210.11582@boston.corp.fedex.com>
	 <Pine.LNX.4.64.1004090336410.22139@boston.corp.fedex.com>
	 <1270759800.19330.19.camel@wwguy-ubuntu>
	 <k2yb6a2187b1004081736td3a4c0f3uc05451902bec39a5@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 08 Apr 2010 20:15:04 -0700
Message-Id: <1270782904.28602.1.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On Thu, 2010-04-08 at 17:36 -0700, Jeff Chua wrote:
> 
> 
> On Fri, Apr 9, 2010 at 4:50 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com>
> wrote:
>         do not need to check sta_id == IWL_INVALID_STATION here since
>         already
>         check before.
>         could you try my revised version of patch I send after my
>         first attempt.
>         to make sure it works.
>         
>         I attach here again in case you did not get it.
> 
> Wey,
>  
> One small touch-up. Again, I've to rename "iwlagn_" to "iwl_" so that
> it can apply to Linus's base code.
> 
> Tested and working fine. Here's the updated patch.
> 
Thanks for verify the patch, you are correct, since I am using the
wireless-testing version of the kernel, you will need to make the
changes in order to get the patch apply. Sorry for the trouble.

Regards
Wey

> 
> 
> 

