Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab1GKWmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 18:42:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48839 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758177Ab1GKWmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 18:42:52 -0400
Date: Tue, 12 Jul 2011 07:42:45 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jesper Juhl <jj@chaosbits.net>, Arnaud Lacombe <lacombar@gmail.com>,
        Pekka Enberg <penberg@kernel.org>,
        Am?rico Wang <xiyou.wangcong@gmail.com>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        linux-kbuild@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid Wunused-but-set warning
Message-ID: <20110711224243.GB32033@opensource.wolfsonmicro.com>
References: <CACqU3MUgVTpc6kBvBiw7rtyn_JTA-JPrbnvai3Vnq+UWk-jSbQ@mail.gmail.com>
 <CAOJsxLF+4VOXJwRJL7npMngDTGztXk739_GcMLxsMzmsVcDCVw@mail.gmail.com>
 <CACqU3MUFO9DGqnK99ApaKn00vzj5rCB5=kjuSZGZpPU8c_4G-A@mail.gmail.com>
 <20110710110241.7650e03f.rdunlap@xenotime.net>
 <alpine.LNX.2.00.1107110051420.2818@swampdragon.chaosbits.net>
 <20110710160722.ae763029.rdunlap@xenotime.net>
 <alpine.LNX.2.00.1107110117080.2818@swampdragon.chaosbits.net>
 <20110710165333.8c7f9620.rdunlap@xenotime.net>
 <20110711050951.GA22699@sirena.org.uk>
 <20110711101134.613d88ee.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711101134.613d88ee.rdunlap@xenotime.net>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 10:11:34AM -0700, Randy Dunlap wrote:
> On Mon, 11 Jul 2011 06:09:52 +0100 Mark Brown wrote:

> > Current practice seems to be that Acked-by is used instead of
> > Reviewed-by - the latter is comparatively rare.

> ISTM that more education and encouragement are needed about Reviewed-by:.
> (Patch Review is a possible kernel summit topic.)

> and that SubmittingPatches should be updated since we generally refer people
> to that file and not to Documentation/development-process/

I'm not sure I see any value in that - they're both pretty much
interchangible as far as I can tell.  The important thing is that people
are doing review, not the form filling part.
