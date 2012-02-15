Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab2BOVro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 16:47:44 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:32833 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab2BOVrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 16:47:43 -0500
Date: Wed, 15 Feb 2012 16:47:10 -0500 (EST)
Message-Id: <20120215.164710.1142246626753412621.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: dkukawka@suse.de, mingo@elte.hu, joe@perches.com, a.p.zijlstra@chello.nl,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/sparc/kernel/unaligned_64.c: included
 linux/bitops.h twice
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329333604-31883-1-git-send-email-danny.kukawka@bisect.de>
References: <1329333604-31883-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 15 Feb 2012 13:47:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Wed, 15 Feb 2012 20:20:04 +0100

> arch/sparc/kernel/unaligned_64.c included 'linux/bitops.h' twice,
> remove the duplicate.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied, thanks.
