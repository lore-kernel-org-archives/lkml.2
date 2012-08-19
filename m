Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2HSPan (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 11:30:43 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:56476 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2HSPah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 11:30:37 -0400
X-Auth-Info: LXbPTWn/bXJaQK9nahs5/8ESiduGPp8gFHjTVMHwF80=
From: Marek Vasut <marex@denx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] IIO: arm: Add LRADC to i.MX28 dts
Date: Sun, 19 Aug 2012 17:30:31 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-iio@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        "Lars-Peter Clausen" <lars@metafoo.de>
References: <1344784918-32352-1-git-send-email-marex@denx.de> <201208170457.03686.marex@denx.de> <CAAQ0ZWROobdtFkzn9Sr7v5B29zYTQ5YEUZV59kkNE_yv6qbmgQ@mail.gmail.com>
In-Reply-To: <CAAQ0ZWROobdtFkzn9Sr7v5B29zYTQ5YEUZV59kkNE_yv6qbmgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208191730.31969.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Shawn Guo,

> On 17 August 2012 10:57, Marek Vasut <marex@denx.de> wrote:
> > Thanks ... still, is there some key for those tags? Or do you invent them
> > at random and then let people guess what's right? Some git grep on
> > Documentation directory gets me nothing.
> 
> There is no official document for this.

Hm, maybe such document can be introduced?

> But generally, each subsystem
> has a convention on the subject prefix, so that the output of git
> commands like git pull, git shortlog looks consistent on the patch
> subject, and more importantly people can easily know subsystem the
> patch touches.
> 
> The convention for patches touching arch/arm is "ARM: ".
> 
> Regards,
> Shawn

Best regards,
Marek Vasut
