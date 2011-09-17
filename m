Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1IQTSq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 15:18:46 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:43322 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab1IQTSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 15:18:45 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Sep 2011 15:18:45 EDT
Date: Sat, 17 Sep 2011 21:12:21 +0200
From: Andreas Mohr <andi@lisas.de>
To: Arkaprava Basu <arkaprava.basu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: TLB flush question (x86_64)
Message-ID: <20110917191221.GA24295@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErB21iHz_ToVzfU8aPkY8OW5iMOTPgPMdQBsmxo=5YUCMb6Aw@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

decided to reply since there hasn't been any activity yet.

> Is there any particular reason why
> the entire address space is flushed from the tlb while only a range of
> virtual address space was supposedly required to be flushed?

While this particular function has actually changed in less medieval
kernel versions, it would be nice if someone knew an answer to that,
especially since TLB activity may have grave performance implications.

Andreas Mohr
