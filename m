Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab2J3X0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 19:26:43 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:49828 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2J3X0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 19:26:41 -0400
Date: Tue, 30 Oct 2012 23:26:40 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Tony Lindgren <tony@atomide.com>
cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, hvaibhav@ti.com
Subject: Re: [PATCH] omap2-clk: Add missing lcdc clock definition
In-Reply-To: <20121030181837.GM11908@atomide.com>
Message-ID: <alpine.DEB.2.00.1210302324530.6152@utopia.booyaka.com>
References: <1351698962-3923-1-git-send-email-panto@antoniou-consulting.com> <20121030181837.GM11908@atomide.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Vaibhav Hiremath

On Tue, 30 Oct 2012, Tony Lindgren wrote:

> * Pantelis Antoniou <panto@antoniou-consulting.com> [121030 11:04]:
> > Looks like the lcdc clock definition got dropped.
> > It is required for the LCD controller to work. Reintroduce.
> 
> This looks like a regression, can you also add the commit
> causing it?

Looks like probably a new "feature," in that this clock didn't exist in 
the original check-in.  Would be good to get Vaibhav's opinion on this; 
also the common clock patches will need to be updated.


- Paul
