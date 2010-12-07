Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0LGPQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:16:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54109 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754353Ab0LGPQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:16:15 -0500
Date: Tue, 7 Dec 2010 15:16:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        lrg@slimlogic.co.uk
Subject: Re: [PATCH 29/29] drivers/regulator: Update WARN uses
Message-ID: <20101207151608.GC9689@rakim.wolfsonmicro.main>
References: <b0588ea464d551f9dbd80c0fee68a780d6279b50.1291670106.git.joe@perches.com>
 <20101207114346.GC10722@sirena.org.uk>
 <alpine.LNX.2.00.1012071549150.14806@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1012071549150.14806@pobox.suse.cz>
X-Cookie: E Pluribus Unix
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 03:50:32PM +0100, Jiri Kosina wrote:
> On Tue, 7 Dec 2010, Mark Brown wrote:

> > On Mon, Dec 06, 2010 at 02:05:19PM -0800, Joe Perches wrote:
> > > Align arguments.

> > > Signed-off-by: Joe Perches <joe@perches.com>

> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> > but please do remember to send patches to maintainers - trying to merge
> > patches without going through the maintainers means that people working
> > on the actual tree concerned may either replicate your work or introduce
> > conflicts with your patches, neither of which is good.

> That happened here:

> 	https://lkml.org/lkml/2010/11/1/107

> but the patch is not in linux-next after more than one month. Which is why 
> Joe is resending it for inclusion through my queue.

That's not a reason to drop people from the CCs when reposting, and when
reposting it's always good to include any reviews you got previously.
Indeed, looking at the original posting you'll see he sent it directly
to you first time around as well as CCing the maintainers.
