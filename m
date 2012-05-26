Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab2EZTxg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 15:53:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35804 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab2EZTxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 15:53:35 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <CA+55aFyAj5GhuNd88AkxUpM72v-ZvvGjgaajD51fS4KHO2ovzg@mail.gmail.com>
References: <1338016958-7887-1-git-send-email-olof@lixom.net>
	<1338016958-7887-5-git-send-email-olof@lixom.net>
	<CA+55aFyAj5GhuNd88AkxUpM72v-ZvvGjgaajD51fS4KHO2ovzg@mail.gmail.com>
Date: Sat, 26 May 2012 12:53:34 -0700
Message-ID: <CAOesGMjOH5N4DEOrfyuTK+GLy8i_RNZUz-Cv64c6=99oF=hvgg@mail.gmail.com>
Subject: Re: [GIT PULL 4/8] arm-soc: clock driver changes
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 12:47 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, May 26, 2012 at 12:22 AM, Olof Johansson <olof@lixom.net> wrote:
>>
>>  151 files changed, 8310 insertions(+), 14192 deletions(-)
>
> Judging by the diffstat, I think we resolved this differently.
>
> I also removed the
>
>  #include <linux/of.h>
>
> from mach-kirkwood/common.c, since the OF users all got removed. You
> have one less lines deleted than I do, which makes me think you didn't
> remove that header file include.
>
> But I didn't actually check. I thought I'd mention it, just so that it
> doesn't come back (or, assuming I did the wrong thing, you fix it up
> and put it back)

Good catch. Yes, I did indeed keep it and there is no need to do so
since it was only used in the code that got removed. Your resolution
is good. Thanks for the heads up.


Regards,

-Olof
