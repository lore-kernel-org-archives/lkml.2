Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab1GMBPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 21:15:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59087 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1GMBPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 21:15:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110711101134.613d88ee.rdunlap@xenotime.net>
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
Date: Wed, 13 Jul 2011 09:15:42 +0800
Message-ID: <CAM_iQpUSj5rQgMds6LppD1fM=w3z=CZ9An1OVv__cTM5u+PB3Q@mail.gmail.com>
Subject: Re: [PATCH] Avoid Wunused-but-set warning
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jesper Juhl <jj@chaosbits.net>, Arnaud Lacombe <lacombar@gmail.com>,
        Pekka Enberg <penberg@kernel.org>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        linux-kbuild@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 1:11 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Mon, 11 Jul 2011 06:09:52 +0100 Mark Brown wrote:
>
>> On Sun, Jul 10, 2011 at 04:53:33PM -0700, Randy Dunlap wrote:
>>
>> > But do as you like.  Which parts of SubmittingPatches do you think
>> > support your interpretation?
>>
>> > and should we have this line:
>> >     Acked-by: is not as formal as Signed-off-by:.
>> > changed to:
>> >     Acked-by: is not as formal as Signed-off-by: or Reviewed-by:.
>> > e.g.?
>>
>> Current practice seems to be that Acked-by is used instead of
>> Reviewed-by - the latter is comparatively rare.
>
>
> ISTM that more education and encouragement are needed about Reviewed-by:.
> (Patch Review is a possible kernel summit topic.)
>
> and that SubmittingPatches should be updated since we generally refer people
> to that file and not to Documentation/development-process/

Agreed, mind to send a patch? ;-)

>
> Samples from my partial mailing list archives:
>
> linux-pci mailing list:         Acked-by: 93    Reviewed-by: 81
> linux-mm mailing list:          Acked-by: 2104  Reviewed-by: 1344
> netdev mailing list:            Acked-by: 1366  Reviewed-by: 659
>

Yup, take netdev as an example, Davem is the only maintainer (not to
say things like wireless)
but definitely people like Eirc or Herbert is qualified to give Acked-by too.

Thanks.
