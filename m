Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab1IUGMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 02:12:12 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:51908 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752385Ab1IUGML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 02:12:11 -0400
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the
 arm-soc tree
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20110921125844.d83e02ba538d7626d6bdefcf@canb.auug.org.au>
References: <20110921125844.d83e02ba538d7626d6bdefcf@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 09:12:04 +0300
Message-ID: <1316585524.1949.6.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, 2011-09-21 at 12:58 +1000, Stephen Rothwell wrote:
> Hi Tomi,
> 
> Today's linux-next merge of the omap_dss2 tree got a conflict in
> arch/arm/mach-omap2/board-4430sdp.c between commit 8f5b5a41ebc7 ("ARM:
> OMAP: Introduce SoC specific early_init") from the arm-soc tree and
> commit 58282610da02 ("OMAP: 4430SDP: Remove unneeded lcd config") from
> the omap_dss2 tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Thanks, looks correct.

 Tomi


