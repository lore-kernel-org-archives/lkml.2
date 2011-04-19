Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1DSHDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 03:03:39 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:39557 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217Ab1DSHDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:03:36 -0400
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the
 fbdev-current tree
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Archit Taneja <archit@ti.com>, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20110419132720.d86b8afd.sfr@canb.auug.org.au>
References: <20110419132720.d86b8afd.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 10:03:30 +0300
Message-ID: <1303196610.2141.14.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, 2011-04-19 at 13:27 +1000, Stephen Rothwell wrote:
> Hi Tomi,
> 
> Today's linux-next merge of the omap_dss2 tree got a conflict in
> drivers/video/omap2/dss/dss_features.c
> drivers/video/omap2/dss/dss_features.h between commit 0b41136c0d2f
> ("OMAP: DSS2: DSI: Fix DSI PLL power bug") from the fbdev-current tree
> and commit 0f7d043bd56b ("OMAP4: DSS2: Register configuration changes for
> DSI") from the omap_dss2 tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

This was actually my mistake, sorry. I had wrong commits in my for-next
branch. I've update it to latest correct stuff, and the problem should
disappear.

 Tomi


