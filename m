Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab1GKRLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 13:11:38 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:41108 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757979Ab1GKRLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 13:11:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Du4FZPW5YCnDkfnLOnFehtgu+ieF0U3U9EmKhqm1+e5OXxZy4oDDninvMjLyq5+9M1QAFvuaM1No38uw68e5FfQLeLMc0iVuSC7ujkp61hrKEVwdyUCC0WAcIjl/K7vO;
Date: Mon, 11 Jul 2011 10:11:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jesper Juhl <jj@chaosbits.net>, Arnaud Lacombe <lacombar@gmail.com>,
        Pekka Enberg <penberg@kernel.org>,
        Am?rico Wang <xiyou.wangcong@gmail.com>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        linux-kbuild@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid Wunused-but-set warning
Message-Id: <20110711101134.613d88ee.rdunlap@xenotime.net>
In-Reply-To: <20110711050951.GA22699@sirena.org.uk>
References: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net>
	<CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com>
	<CACqU3MUgVTpc6kBvBiw7rtyn_JTA-JPrbnvai3Vnq+UWk-jSbQ@mail.gmail.com>
	<CAOJsxLF+4VOXJwRJL7npMngDTGztXk739_GcMLxsMzmsVcDCVw@mail.gmail.com>
	<CACqU3MUFO9DGqnK99ApaKn00vzj5rCB5=kjuSZGZpPU8c_4G-A@mail.gmail.com>
	<20110710110241.7650e03f.rdunlap@xenotime.net>
	<alpine.LNX.2.00.1107110051420.2818@swampdragon.chaosbits.net>
	<20110710160722.ae763029.rdunlap@xenotime.net>
	<alpine.LNX.2.00.1107110117080.2818@swampdragon.chaosbits.net>
	<20110710165333.8c7f9620.rdunlap@xenotime.net>
	<20110711050951.GA22699@sirena.org.uk>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011 06:09:52 +0100 Mark Brown wrote:

> On Sun, Jul 10, 2011 at 04:53:33PM -0700, Randy Dunlap wrote:
> 
> > But do as you like.  Which parts of SubmittingPatches do you think
> > support your interpretation?
> 
> > and should we have this line:
> > 	Acked-by: is not as formal as Signed-off-by:.
> > changed to:
> > 	Acked-by: is not as formal as Signed-off-by: or Reviewed-by:.
> > e.g.?
> 
> Current practice seems to be that Acked-by is used instead of
> Reviewed-by - the latter is comparatively rare.


ISTM that more education and encouragement are needed about Reviewed-by:.
(Patch Review is a possible kernel summit topic.)

and that SubmittingPatches should be updated since we generally refer people
to that file and not to Documentation/development-process/


Samples from my partial mailing list archives:

linux-pci mailing list:		Acked-by: 93	Reviewed-by: 81
linux-mm mailing list:		Acked-by: 2104	Reviewed-by: 1344
netdev mailing list:		Acked-by: 1366	Reviewed-by: 659

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
