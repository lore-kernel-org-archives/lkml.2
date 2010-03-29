Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab0C2OCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:02:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:56653 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab0C2OCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:02:23 -0400
Message-ID: <4BB0B2AB.2060207@windriver.com>
Date: Mon, 29 Mar 2010 09:01:15 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] kgdb fixes for 2.6.34-rc2
References: <1269285449-1424-1-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1269285449-1424-1-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2010 14:01:15.0706 (UTC) FILETIME=[4C3BC1A0:01CACF48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 02:17 PM, Jason Wessel wrote:
> Linus, please pull the kgdb-fixes for 2.6.34.  
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git kgdb-fixes
>
> Summary:
>   * The first 2 patches are the gdbstub and debug core split from the kdb tree
>   * The rest are the fixes cherry picked from the kdb pull request
>
> The previous kdb pull will require a rebase if you accept the kgdb
> fixes because there were patch splits that occurred to make this patch
> set.
>
>   

Ping.

Linus, please help me understand how we can continue to move forward on
the kernel debugger pull requests.  There have been numerous requests
that have not been pulled and have no response as to what needs to be
acted on to resolve any outstanding issues.

Thanks,
Jason.


