Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1GJQvZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 12:51:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39749 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab1GJQvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 12:51:22 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MUFO9DGqnK99ApaKn00vzj5rCB5=kjuSZGZpPU8c_4G-A@mail.gmail.com>
References: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net>
	<CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com>
	<CACqU3MUgVTpc6kBvBiw7rtyn_JTA-JPrbnvai3Vnq+UWk-jSbQ@mail.gmail.com>
	<CAOJsxLF+4VOXJwRJL7npMngDTGztXk739_GcMLxsMzmsVcDCVw@mail.gmail.com>
	<CACqU3MUFO9DGqnK99ApaKn00vzj5rCB5=kjuSZGZpPU8c_4G-A@mail.gmail.com>
Date: Mon, 11 Jul 2011 00:51:21 +0800
Message-ID: <CAM_iQpVp4CobPsDnb4Z2xPFtin_+qGdPSkyyK=z6aedTfvKVBQ@mail.gmail.com>
Subject: Re: [PATCH] Avoid Wunused-but-set warning
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        linux-kbuild@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 12:49 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>
> That said, it is not a strong requirement... unfortunately. So, let's
> have some fun and go ACK thousand of trivial patch just to generate
> traffic on the LKML and give myself self-importance :-)

That is how LKML works, get used to it.
