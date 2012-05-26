Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2EZTr7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 15:47:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63005 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2EZTr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 15:47:58 -0400
MIME-Version: 1.0
In-Reply-To: <1338016958-7887-5-git-send-email-olof@lixom.net>
References: <1338016958-7887-1-git-send-email-olof@lixom.net> <1338016958-7887-5-git-send-email-olof@lixom.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 26 May 2012 12:47:35 -0700
X-Google-Sender-Auth: JGyrjnzixMEwPHFQ1vbS0RKx9FY
Message-ID: <CA+55aFyAj5GhuNd88AkxUpM72v-ZvvGjgaajD51fS4KHO2ovzg@mail.gmail.com>
Subject: Re: [GIT PULL 4/8] arm-soc: clock driver changes
To: Olof Johansson <olof@lixom.net>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 12:22 AM, Olof Johansson <olof@lixom.net> wrote:
>
>  151 files changed, 8310 insertions(+), 14192 deletions(-)

Judging by the diffstat, I think we resolved this differently.

I also removed the

  #include <linux/of.h>

from mach-kirkwood/common.c, since the OF users all got removed. You
have one less lines deleted than I do, which makes me think you didn't
remove that header file include.

But I didn't actually check. I thought I'd mention it, just so that it
doesn't come back (or, assuming I did the wrong thing, you fix it up
and put it back)

                  Linus
