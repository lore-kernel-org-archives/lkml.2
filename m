Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab1GMCVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 22:21:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46170 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab1GMCVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 22:21:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAM_iQpUSj5rQgMds6LppD1fM=w3z=CZ9An1OVv__cTM5u+PB3Q@mail.gmail.com>
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
Date: Tue, 12 Jul 2011 22:21:37 -0400
Message-ID: <CACqU3MXujqdjur3keSF78+5qKs-j7NN4iz_YMHgH7_8D=3EdLQ@mail.gmail.com>
Subject: Re: [PATCH] Avoid Wunused-but-set warning
From: Arnaud Lacombe <lacombar@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jesper Juhl <jj@chaosbits.net>, Pekka Enberg <penberg@kernel.org>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        linux-kbuild@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 12, 2011 at 9:15 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Tue, Jul 12, 2011 at 1:11 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> On Mon, 11 Jul 2011 06:09:52 +0100 Mark Brown wrote:
>>
>>> On Sun, Jul 10, 2011 at 04:53:33PM -0700, Randy Dunlap wrote:
>>>
>>> > But do as you like.  Which parts of SubmittingPatches do you think
>>> > support your interpretation?
>>>
>>> > and should we have this line:
>>> >     Acked-by: is not as formal as Signed-off-by:.
>>> > changed to:
>>> >     Acked-by: is not as formal as Signed-off-by: or Reviewed-by:.
>>> > e.g.?
>>>
>>> Current practice seems to be that Acked-by is used instead of
>>> Reviewed-by - the latter is comparatively rare.
>>
>>
>> ISTM that more education and encouragement are needed about Reviewed-by:.
>> (Patch Review is a possible kernel summit topic.)
>>
>> and that SubmittingPatches should be updated since we generally refer people
>> to that file and not to Documentation/development-process/
>
> Agreed, mind to send a patch? ;-)
>
>>
>> Samples from my partial mailing list archives:
>>
>> linux-pci mailing list:         Acked-by: 93    Reviewed-by: 81
>> linux-mm mailing list:          Acked-by: 2104  Reviewed-by: 1344
>> netdev mailing list:            Acked-by: 1366  Reviewed-by: 659
>>
>
> Yup, take netdev as an example, Davem is the only maintainer (not to
> say things like wireless)
> but definitely people like Eirc or Herbert is qualified to give Acked-by too.
>
I have the feeling from this thread that "Acked-by:" does not need any
particular qualification, whereas Reviewed-by: "kinda" does. But I may
have understood that all wrong. Btw, I say "kinda" as I see nothing in
the Reviewed-by: or Acked-by: definition that require any
qualification on the involved subsystem to give an Acked-by: or a
Reviewed-by:. Maybe we [not?] need such some formal requirement.

Just to highlight my point, you have never had any involvement[0] in
scripts/kconfig/, but still gave an Acked-by:, how trivial the
original patch might have been[1].

 - Arnaud

[0]: git's history can back me on this affirmation, no matter what you
affirm, even using the linux-glx-history.git tree, as long as kconfig
has been held in scripts/kconfig; .gitignore fixes does not count.

[1]: please do not see any kind attack here, that's not the point.
