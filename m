Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1HYQeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:34:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:37129 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab1HYQeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:34:05 -0400
Message-ID: <4E56796F.8090703@windriver.com>
Date: Thu, 25 Aug 2011 12:33:51 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jon Medhurst <tixy@yxit.co.uk>, Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the moduleh tree with the arm tree
References: <20110825151748.8e41e0ded739187a1432cf0b@canb.auug.org.au>
In-Reply-To: <20110825151748.8e41e0ded739187a1432cf0b@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-08-25 01:17 AM, Stephen Rothwell wrote:
> Hi Paul,
> 
> Today's linux-next merge of the moduleh tree got a conflict in
> arch/arm/mach-bcmring/mm.c between commit 2d5e975b2194 ("ARM:
> mach-bcmring: Setup consistent dma size at boot time") from the arm tree
> and commit 9bc7d81e271e ("arm: fix implicit use of page.h in
> mach-bcmring/mach-jornada") from the moduleh tree.

I can't really relocate the page.h inclusion in a trivial way to
make this conflict go away.  But since the implicit header use fixes
for arm are independent and don't actually depend on anything in the
rest of the module.h tree, I can set about to giving these to Russell
for his arm-next branch anytime.  I'll do that shortly.

Thanks,
Paul.

> 
> Jst context changes I fixed it up (see below) and can carry the fix as
> necessary.
