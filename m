Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1GJRY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 13:24:27 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34679 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab1GJRYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 13:24:24 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MUFO9DGqnK99ApaKn00vzj5rCB5=kjuSZGZpPU8c_4G-A@mail.gmail.com>
References: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net>
	<CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com>
	<CACqU3MUgVTpc6kBvBiw7rtyn_JTA-JPrbnvai3Vnq+UWk-jSbQ@mail.gmail.com>
	<CAOJsxLF+4VOXJwRJL7npMngDTGztXk739_GcMLxsMzmsVcDCVw@mail.gmail.com>
	<CACqU3MUFO9DGqnK99ApaKn00vzj5rCB5=kjuSZGZpPU8c_4G-A@mail.gmail.com>
Date: Sun, 10 Jul 2011 20:24:24 +0300
X-Google-Sender-Auth: ygkjtYp_ClXI6AX-9w9IBXGooNw
Message-ID: <CAOJsxLHW_9+8kqJpK=fjr=MXY2R99iTj0j_F6_JHyWDQextf6A@mail.gmail.com>
Subject: Re: [PATCH] Avoid Wunused-but-set warning
From: Pekka Enberg <penberg@kernel.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        linux-kbuild@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaud!

On Sun, Jul 10, 2011 at 7:49 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> What kind of status do you need to ACK such a simple patch?
>>
> As per Documentation/SubmittingPatches:

[snip]

> That said, it is not a strong requirement... unfortunately. So, let's
> have some fun and go ACK thousand of trivial patch just to generate
> traffic on the LKML and give myself self-importance :-)

Hey, thank you so much for quoting Documentation/SubmittingPatches for me!

I've read it a long time ago but I now see I've completely
misunderstood how things work around here. How silly of me to assume
patches posted on LKML were fair game for anyone to review and that it
was appreciated given that there's chronic lack of reviewers for
pretty much everything. Thank you for setting me straight on the
subject!

I see you've been rather busy with important Kconfg work recently but
I can only hope you'll find the time to enforce "Acked-by" status on
LKML in the future as well!

P.S. There are other tags such as Tested-by and Reviewed-by which you
might also want to police a bit as well - I hear people without proper
testing or reviewing status are doing those things all the time!

                               Pekka
