Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab0DSQU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 12:20:29 -0400
Received: from borg.medozas.de ([188.40.89.202]:45213 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab0DSQU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 12:20:27 -0400
Date: Mon, 19 Apr 2010 18:20:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: [patch] vt: deactive Shift In/Out in unicode mode
In-Reply-To: <20100419153136.3585281f@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LSU.2.01.1004191812570.25222@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1004191555290.17067@obet.zrqbmnf.qr> <20100419153136.3585281f@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2010-04-19 16:31, Alan Cox wrote:
>> 
>> I am proposing the patch below for inclusion.
>> Also pullable via
>> 	git://dev.medozas.de/linux siso
>
>It seems to do a lot of other things as well. Can you split out just the
>relevant bit ?

It's really just the top commit. Perhaps I should rebase it to a
v2.6.34-rcX tag so that shortlog does what one expects.

Alexander mentioned:

[quoting the gmane nntp posting which was stripped of To:s and Cc:s]
>
>Since KOI7 is not used by any glibc locale, your use case is now 
>extinct. I think that, unless someone finds out a different use case, 
>these SI and SO characters should be deactivated completely (and not 
>just in unicode mode).

Alan, do you agree that the entire SI/SO can/should be removed?
