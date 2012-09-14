Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab2INS2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:28:54 -0400
Received: from mail.digium.com ([216.207.245.2]:35965 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab2INS2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:28:51 -0400
Date: Fri, 14 Sep 2012 13:21:37 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Shaohui Xie <Shaohui.Xie@freescale.com>
Cc: linux-edac@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        akpm@linux-foundation.org, avorontsov@mvista.com,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca
Subject: Re: [PATCH] edac/85xx: fix error handle of mpc85xx_mc_err_probe
Message-ID: <20120914182137.GD18672@digium.com>
References: <1347533729-5893-1-git-send-email-Shaohui.Xie@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347533729-5893-1-git-send-email-Shaohui.Xie@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 06:55:29PM +0800, Shaohui Xie wrote:
> Error handle in case of DDR ECC off is wrong, sysfs entries have not been
> created, so edac_mc_free which frees a mci instance should not be called.
> Also, free mci's memory in this case.

Jus FYI: I ran into the same error in edac_mc_free() which I
resolved in a slightly different way in some patches I sent
previously. [1]

[1] https://lkml.org/lkml/2012/9/14/475 

Cheers,
Shaun
