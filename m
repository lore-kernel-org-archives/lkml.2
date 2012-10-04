Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2JDSXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:23:48 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44527 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab2JDSXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:23:37 -0400
Date: Thu, 04 Oct 2012 14:23:35 -0400 (EDT)
Message-Id: <20121004.142335.1467206545795435493.davem@davemloft.net>
To: peter.senna@gmail.com
Cc: shemminger@vyatta.com, mlindner@marvell.com,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/20] drivers/net/ethernet/marvell/skge.c: fix error
 return code
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+MoWDp=_F9opJbVkv9sDsmoykm7MTUZwRVumKCB0ZqDwD6NoQ@mail.gmail.com>
References: <CA+MoWDp4W5BCA1t_HgEtLhMs1btVTOkbtBytOVtAzJriEZ-16A@mail.gmail.com>
	<20121004074442.180d8f01@nehalam.linuxnetplumber.net>
	<CA+MoWDp=_F9opJbVkv9sDsmoykm7MTUZwRVumKCB0ZqDwD6NoQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>
Date: Thu, 4 Oct 2012 19:32:12 +0200

> I can't understand the advantages of describing each patch as you are
> asking. "For me" the generic commit message together with the patch
> makes sense.  Can you please help me on that?

Stop being so dense.

We want to know the implications of the bug being fixed.

Does it potentially cause an OOPS?  Bad reference counting and thus
potential leaks or early frees?

You have to analyze the implications and ramifications of the bug
being fixed.  We need that information.

Your commit messages are in fact robotic, they don't describe the
salient details of what kinds of problems the bug being fixed might
cause.

It's just "bad error code, this is the script that fixed it, kthx,
bye" which is pretty much useless for anaylsis.

