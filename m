Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab1GKFKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 01:10:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39183 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab1GKFKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 01:10:03 -0400
Date: Mon, 11 Jul 2011 06:09:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jesper Juhl <jj@chaosbits.net>, Arnaud Lacombe <lacombar@gmail.com>,
        Pekka Enberg <penberg@kernel.org>,
        Am?rico Wang <xiyou.wangcong@gmail.com>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        linux-kbuild@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid Wunused-but-set warning
Message-ID: <20110711050951.GA22699@sirena.org.uk>
References: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net> <CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com> <CACqU3MUgVTpc6kBvBiw7rtyn_JTA-JPrbnvai3Vnq+UWk-jSbQ@mail.gmail.com> <CAOJsxLF+4VOXJwRJL7npMngDTGztXk739_GcMLxsMzmsVcDCVw@mail.gmail.com> <CACqU3MUFO9DGqnK99ApaKn00vzj5rCB5=kjuSZGZpPU8c_4G-A@mail.gmail.com> <20110710110241.7650e03f.rdunlap@xenotime.net> <alpine.LNX.2.00.1107110051420.2818@swampdragon.chaosbits.net> <20110710160722.ae763029.rdunlap@xenotime.net> <alpine.LNX.2.00.1107110117080.2818@swampdragon.chaosbits.net> <20110710165333.8c7f9620.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110710165333.8c7f9620.rdunlap@xenotime.net>
X-Cookie: Even a hawk is an eagle among crows.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 04:53:33PM -0700, Randy Dunlap wrote:

> But do as you like.  Which parts of SubmittingPatches do you think
> support your interpretation?

> and should we have this line:
> 	Acked-by: is not as formal as Signed-off-by:.
> changed to:
> 	Acked-by: is not as formal as Signed-off-by: or Reviewed-by:.
> e.g.?

Current practice seems to be that Acked-by is used instead of
Reviewed-by - the latter is comparatively rare.
