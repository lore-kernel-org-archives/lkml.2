Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab1DZNDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:03:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59945 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab1DZNDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:03:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] sched: get rid of lock_depth
Date: Tue, 26 Apr 2011 15:03:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Neil Brown <neilb@suse.de>
References: <20110422111910.456c0e84@bike.lwn.net>
In-Reply-To: <20110422111910.456c0e84@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104261503.39419.arnd@arndb.de>
X-Provags-ID: V02:K0:mVrDrDVeUaUHww7rOy3hLBsBJnoK11X1BlAsdzysrJL
 6jhV4YLgqcA+kK2uNp2QNbFoGWtyIWzEImrrJZbBfJWl57mf7f
 wmgrIRtKzK1vwmasNWwLFcL/EY23lO0c/zH0kA0JEKHk4Hp28/
 UyKSIZVvlY4c3DHbXvjuGBWEidFjlKpsYAn3AOHTU2hzVakR7E
 hU8yIAyvewPEABZ6EMW1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 April 2011, Jonathan Corbet wrote:
> Neil Brown pointed out that lock_depth somehow escaped the BKL removal
> work.  Let's get rid of it now.
> 
> Note that the perf scripting utilities still have a bunch of code for
> dealing with common_lock_depth in tracepoints; I have left that in place in
> case anybody wants to use that code with older kernels.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

I wonder how I missed that, I certainly had a patch for this in the
beginning, but must have dropped it from my series later on.

Acked-by: Arnd Bergmann <arnd@arndb.de>
