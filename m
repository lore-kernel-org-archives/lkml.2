Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab1GKFzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 01:55:21 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60270 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab1GKFzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 01:55:20 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1107110117080.2818@swampdragon.chaosbits.net>
References: <da20dc5c4160ed9a3da52f60799a1e4369fe3f27.1310228130.git.rprabhu@wnohang.net>
	<CAM_iQpXeqc01dyHpViyJCMSz6wz-1mWmGi=J0UynUG8tbd99kw@mail.gmail.com>
	<CACqU3MUgVTpc6kBvBiw7rtyn_JTA-JPrbnvai3Vnq+UWk-jSbQ@mail.gmail.com>
	<CAOJsxLF+4VOXJwRJL7npMngDTGztXk739_GcMLxsMzmsVcDCVw@mail.gmail.com>
	<CACqU3MUFO9DGqnK99ApaKn00vzj5rCB5=kjuSZGZpPU8c_4G-A@mail.gmail.com>
	<20110710110241.7650e03f.rdunlap@xenotime.net>
	<alpine.LNX.2.00.1107110051420.2818@swampdragon.chaosbits.net>
	<20110710160722.ae763029.rdunlap@xenotime.net>
	<alpine.LNX.2.00.1107110117080.2818@swampdragon.chaosbits.net>
Date: Mon, 11 Jul 2011 08:55:19 +0300
X-Google-Sender-Auth: gLD36oIBEgn96GnHA9skkCkNe1Q
Message-ID: <CAOJsxLHzXV3MDHH+83iwxaUtO=931Bmq1JRzS=MQx=6wa-wi2w@mail.gmail.com>
Subject: Re: [PATCH] Avoid Wunused-but-set warning
From: Pekka Enberg <penberg@kernel.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Arnaud Lacombe <lacombar@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        linux-kbuild@vger.kernel.org, Nir Tzachar <nir.tzachar@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

On Mon, Jul 11, 2011 at 2:21 AM, Jesper Juhl <jj@chaosbits.net> wrote:
> In any case, you can't expect people to base their Acked-by/Reviewed-by
> replies on some conclusion in some email thread that happened years ago
> but was never written down in some document in the repository.
> It is only reasonable to expect people to behave according to the rules
> laid out in SubmittingPatches and similar documents, and those rules
> currently seem to support my interpretation, not yours.

The definitions in SubmittingPatches are not hard rules and are, in
fact, out of date. See Documentation/development-process/5.Posting for
alternative definitions:

 - Acked-by: indicates an agreement by another developer (often a
   maintainer of the relevant code) that the patch is appropriate for
   inclusion into the kernel.

and

 - Reviewed-by: the named developer has reviewed the patch for correctness;
   see the reviewer's statement in Documentation/SubmittingPatches for more
   detail.

and then compare the dates for these definitions:

0f44cd23 (Andrew Morton      2007-06-08 13:46:45 -0700 401) Acked-by:
is often used by the maintainer of the affected code when that
0f44cd23 (Andrew Morton      2007-06-08 13:46:45 -0700 402) maintainer
neither contributed to nor forwarded the patch.

75b02146 (Jonathan Corbet 2008-09-30 15:15:56 -0600 205)  - Acked-by:
indicates an agreement by another developer (often a
75b02146 (Jonathan Corbet 2008-09-30 15:15:56 -0600 206)    maintainer
of the relevant code) that the patch is appropriate for
75b02146 (Jonathan Corbet 2008-09-30 15:15:56 -0600 207)    inclusion
into the kernel.

So it is NOT reasonable 'to expect people to behave according to the
rules laid out in SubmittingPatches and similar documents' because
such documents have never had any hard rules! The documents are
guidelines that attempt to document how things work here, not lay down
the law.

                                 Pekka
