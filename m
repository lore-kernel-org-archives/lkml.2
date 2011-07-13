Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab1GMMQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 08:16:49 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58129 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab1GMMQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 08:16:47 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MXujqdjur3keSF78+5qKs-j7NN4iz_YMHgH7_8D=3EdLQ@mail.gmail.com>
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
	<20110711101134.613d88ee.rdunlap@xenotime.net>
	<CAM_iQpUSj5rQgMds6LppD1fM=w3z=CZ9An1OVv__cTM5u+PB3Q@mail.gmail.com>
	<CACqU3MXujqdjur3keSF78+5qKs-j7NN4iz_YMHgH7_8D=3EdLQ@mail.gmail.com>
Date: Wed, 13 Jul 2011 15:16:46 +0300
X-Google-Sender-Auth: GqRFosLxP9-GFXEMMtOzWIXZk6s
Message-ID: <CAOJsxLGfsdirEudJ=N9M0aTTqwN65UKcpQygin15ztHWR0qZdw@mail.gmail.com>
Subject: Re: [PATCH] Avoid Wunused-but-set warning
From: Pekka Enberg <penberg@kernel.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jesper Juhl <jj@chaosbits.net>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        linux-kbuild@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 5:21 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> I have the feeling from this thread that "Acked-by:" does not need any
> particular qualification, whereas Reviewed-by: "kinda" does. But I may
> have understood that all wrong. Btw, I say "kinda" as I see nothing in
> the Reviewed-by: or Acked-by: definition that require any
> qualification on the involved subsystem to give an Acked-by: or a
> Reviewed-by:. Maybe we [not?] need such some formal requirement.

The formal requirement for 'Reviewed-by' is that you're OK with Linus
and the gang handing your ass to you on a plate when a patch you've
blessed with your tag breaks the world. 'Acked-by' is similar in
nature but the repercussions are less severe.

                       Pekka
