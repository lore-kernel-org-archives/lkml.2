Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab0LOWh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:37:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64800 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab0LOWhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:37:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH 1/7] msm: io: I/O register definitions for MSM8960
Date: Wed, 15 Dec 2010 23:37:19 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org> <201012151740.24933.arnd@arndb.de> <20101215220317.GA22394@huya.qualcomm.com>
In-Reply-To: <20101215220317.GA22394@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012152337.19475.arnd@arndb.de>
X-Provags-ID: V02:K0:r0uXX2pzZy9mKgRMdSMEawL2KrWhc5nnI0baUO1gNSt
 tIiK+m5bazjAd/6kfy0paeYwv8gBGEl05F+cvMs5XuWQz0pO2c
 Of/AVjoOI7bV0O/JPqATKgOYbkcKlLdEc+KDWhfmzPP4L7oe3m
 22FcpSiLtOF4t8ycZOiOkK4VHimd5G1978uf8HcF8Gv2+Rtjvq
 qXiFZtlPqYjbUSxW80vfA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 December 2010, David Brown wrote:
> 
> On Wed, Dec 15, 2010 at 05:40:24PM +0100, Arnd Bergmann wrote:
> 
> > My point was really that they should not be exclusive, even if they
> > are rather different. If the code is structured in a more modular
> > way, you can turn all MSM/QSD options from the "Qualcomm MSM SoC Type"
> > choice into separate "bool" config options. You probably don't want
> > to do that now for all the existing ones, but I would suggest you
> > try not add more to the pile ;-).
> 
> It's kind of hard to do too much of this, though, until ARM kernels
> can be relocated.  They mostly all live at different base addresses
> (and 8960 might also move).  Throw CPU differences into the mix and it
> gets messier.
> 
> I'm not saying it isn't solvable, but there are a lot of things that
> need to be done to get there.

Yes, I understand that it's hard for many reasons, but my impression
is that there is a general agreement on the idea. As I said, I don't
expect you to fix it all at once, but it shouldn't be too hard
to take care when adding new code.

We already have infrastructure that deals with different CPU cores
in one kernel binary, at least from v5 to v7, and some platforms
like omap and realview can already be built for a variety of very
different machines without such problems.

	Arnd
