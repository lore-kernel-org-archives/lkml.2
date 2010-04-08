Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab0DHRcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:32:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754407Ab0DHRcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:32:35 -0400
Date: Thu, 8 Apr 2010 10:28:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Jones <pjones@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [LKML] Re: [PATCH 1/1] ibft, x86: Change reserve_ibft_region()
 to find_ibft_region()
In-Reply-To: <20100408161210.GA13382@phenom.dumpdata.com>
Message-ID: <alpine.LFD.2.00.1004081027140.3558@i5.linux-foundation.org>
References: <1270741936-1306-1-git-send-email-konrad@kernel.org> <1270741936-1306-2-git-send-email-konrad@kernel.org> <alpine.LFD.2.00.1004080852200.3558@i5.linux-foundation.org> <20100408161210.GA13382@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Apr 2010, Konrad Rzeszutek Wilk wrote:
> 
> Oh, I am definitely ACK-ing. Sorry about not explicitly stating that.
> The developer is Yinghai Lu, I am the co-maintainer of the iBFT driver.
> 
> Linus, would you like me to modify the commit so that it has 'Acked-by:'
> by me in the git tree?

No, no, a sign-off is already an ack, and is "stronger" than an ack, since 
it actually also means that you send it onwards. A patch that you don't 
like you would obviously never sign off on either.

I was more looking for comments from other people who know what the heck 
that early reservation system does.

		Linus
