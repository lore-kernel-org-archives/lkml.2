Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab1BTUVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 15:21:50 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12794 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab1BTUVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 15:21:49 -0500
Date: Sun, 20 Feb 2011 21:20:54 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Borislav Petkov <bp@alien8.de>
cc: Michal Marek <mmarek@suse.cz>, torvalds@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: Add extra gcc checks
In-Reply-To: <1298219710-9846-1-git-send-email-bp@alien8.de>
Message-ID: <alpine.LNX.2.00.1102202119140.11248@swampdragon.chaosbits.net>
References: <1298219710-9846-1-git-send-email-bp@alien8.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Feb 2011, Borislav Petkov wrote:

> Add a 'W=1' Makefile switch which adds additional checking per build
> object.
> 
> The idea behind this option is targeted at developers who, in the
> process of writing their code, want to do the occasional
> 
> make W=1 [target.o]
> 
> and let gcc do more extensive code checking for them. Then, they
> could eyeball the output for valid gcc warnings about various
> bugs/discrepancies which are not reported during the normal build
> process.
> 

I like this. I often modify the Makefile to add something similar to this 
for my local builds. This will save me having to do that in the future.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

