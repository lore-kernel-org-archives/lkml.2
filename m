Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab0DHP6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 11:58:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758637Ab0DHP6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 11:58:05 -0400
Date: Thu, 8 Apr 2010 08:53:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Jones <pjones@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/1] ibft, x86: Change reserve_ibft_region() to
 find_ibft_region()
In-Reply-To: <1270741936-1306-2-git-send-email-konrad@kernel.org>
Message-ID: <alpine.LFD.2.00.1004080852200.3558@i5.linux-foundation.org>
References: <1270741936-1306-1-git-send-email-konrad@kernel.org> <1270741936-1306-2-git-send-email-konrad@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Apr 2010, Konrad Rzeszutek Wilk wrote:
>
> So arch code could decide the way to reserve the ibft.
> 
> And We should reserve ibft as early as possible, instead of BOOTMEM stage,
> in case the table is in RAM range and is not reserved by BIOS.

For all I know this is all perfectly fine, but I have _no_ idea about how 
ibft is supposed to work, so I can't really judge it. As a result, I won't 
pull it without some more acks from people who actually know what that 
thing is..

		Linus
