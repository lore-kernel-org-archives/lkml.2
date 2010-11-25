Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab0KYNjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:39:52 -0500
Received: from borg.medozas.de ([188.40.89.202]:37253 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab0KYNju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:39:50 -0500
Date: Thu, 25 Nov 2010 14:39:49 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] Prepare the tree for un-inlined jhash.
In-Reply-To: <1290690908-794-2-git-send-email-kadlec@blackhole.kfki.hu>
Message-ID: <alpine.LNX.2.01.1011251439160.21752@obet.zrqbmnf.qr>
References: <1290690908-794-1-git-send-email-kadlec@blackhole.kfki.hu> <1290690908-794-2-git-send-email-kadlec@blackhole.kfki.hu>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 2010-11-25 14:15, Jozsef Kadlecsik wrote:

>jhash is widely used in the kernel and because the functions
>are inlined, the cost in size is significant. Also, the new jhash
>functions are slightly larger than the previous ones so better un-inline.
>As a preparation step, the calls to the internal macros are replaced
>with the plain jhash function calls.

Do you have a non-normative allyesconfig/allmodconfig build whose 
size(1) you can run on, to show approximately just how much it differs?


thanks,
Jan
