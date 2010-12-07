Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab0LGOuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:50:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:54752 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab0LGOun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:50:43 -0500
Date: Tue, 7 Dec 2010 15:50:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        lrg@slimlogic.co.uk
Subject: Re: [PATCH 29/29] drivers/regulator: Update WARN uses
In-Reply-To: <20101207114346.GC10722@sirena.org.uk>
Message-ID: <alpine.LNX.2.00.1012071549150.14806@pobox.suse.cz>
References: <b0588ea464d551f9dbd80c0fee68a780d6279b50.1291670106.git.joe@perches.com> <20101207114346.GC10722@sirena.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, Mark Brown wrote:

> On Mon, Dec 06, 2010 at 02:05:19PM -0800, Joe Perches wrote:
> > Align arguments.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> but please do remember to send patches to maintainers - trying to merge
> patches without going through the maintainers means that people working
> on the actual tree concerned may either replicate your work or introduce
> conflicts with your patches, neither of which is good.

That happened here:

	https://lkml.org/lkml/2010/11/1/107

but the patch is not in linux-next after more than one month. Which is why 
Joe is resending it for inclusion through my queue.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
