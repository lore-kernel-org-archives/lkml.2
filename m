Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab2AWMDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 07:03:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44767 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363Ab2AWMDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 07:03:17 -0500
Date: Mon, 23 Jan 2012 12:03:14 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v2] ASoC: da7210: Add support for PLL and SRM
Message-ID: <20120123120313.GC29465@opensource.wolfsonmicro.com>
References: <1327313241.31594.12.camel@matrix>
 <20120123112142.GA29465@opensource.wolfsonmicro.com>
 <1327320561.31594.23.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327320561.31594.23.camel@matrix>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 05:39:21PM +0530, Ashish Chavan wrote:
> On Mon, 2012-01-23 at 11:21 +0000, Mark Brown wrote:
> > On Mon, Jan 23, 2012 at 03:37:21PM +0530, Ashish Chavan wrote:

> > ...this code is shared between both branches (as well as the SRM case)
> > and should be factored out between them.

> We are picking values from three different tables in three cases. Even
> if we factor out this code, we will need a switch or if-else to identify
> correct table. As we are already checking those conditions, I put the
> code there. Can you please elaborate a bit, in case if I misunderstood
> your point?

The only difference between these relatively large chunks of code is the
table that's being referenced.  Either use a single table or factor
things out so that you're sharing all the code that doesn't pick the
table.
