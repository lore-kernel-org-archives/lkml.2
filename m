Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1DSHBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 03:01:35 -0400
Received: from linux-sh.org ([111.68.239.195]:60026 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab1DSHBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:01:34 -0400
Date: Tue, 19 Apr 2011 16:01:14 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Archit Taneja <archit@ti.com>
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the fbdev-current tree
Message-ID: <20110419070114.GA7582@linux-sh.org>
References: <20110419132720.d86b8afd.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419132720.d86b8afd.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 01:27:20PM +1000, Stephen Rothwell wrote:
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

Hmm, both changes came from the omap_dss2 tree, I wonder what's going on?
