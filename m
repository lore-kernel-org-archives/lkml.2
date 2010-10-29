Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257Ab0J2Rzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 13:55:38 -0400
Received: from smtp.citrix.com ([66.165.176.89]:32581 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934203Ab0J2Rzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:55:36 -0400
X-IronPort-AV: E=Sophos;i="4.58,260,1286164800"; 
   d="scan'208";a="10873518"
Subject: Re: [Xen-devel] Re: [PATCH] xen: correct size of level2_kernel_pgt
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4CCB0836.3040200@goop.org>
References: <1288367779-24001-1-git-send-email-ian.campbell@citrix.com>
	 <4CCB02DC.1010307@goop.org>
	 <1288373855.8069.27.camel@localhost.localdomain>
	 <4CCB0836.3040200@goop.org>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Fri, 29 Oct 2010 18:55:33 +0100
Message-ID: <1288374933.8069.63.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 18:45 +0100, Jeremy Fitzhardinge wrote:
> On 10/29/2010 10:37 AM, Ian Campbell wrote:
> > On Fri, 2010-10-29 at 18:22 +0100, Jeremy Fitzhardinge wrote:
> >> On 10/29/2010 08:56 AM, Ian Campbell wrote:
> >>> sizeof(pmd_t *) is 4 bytes on PAE leading to an allocation of only
> >>> 2048 bytes. The correct size is sizeof(pmd_t) giving us a full page
> >>> allocation.
> >>>
> >>> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> >>> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> >>> ---
> >>>
> >>> Applies to mainline since 2.6.36 and to xen.git 2.6.32 based trees
> >> This is just for 2.6.37?
> > 2.6.36.stable too, I think. I added stable@kernel.org to my patch header
> > but didn't "guilt refresh" so it didn't show up here.
> 
> The extend_brk() stuff was all merged this merge window.  I checked out
> .36 to confirm, and there's nothing there for your patch to apply to...

Ah, I was suffering the classic confusion regarding a branch from before
a release getting merged after. Thanks!

Ian.


