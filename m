Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab0CUCOp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 22:14:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:50280 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab0CUCOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 22:14:44 -0400
Message-ID: <4BA58100.2000104@windriver.com>
Date: Sat, 20 Mar 2010 21:14:24 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: kgdb-bugreport@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: [RESEND] Re: [Kgdb-bugreport] [GIT PULL] V2 kdb / early debug (1
 of 2) for 2.6.34
References: <1267420188-10227-1-git-send-email-jason.wessel@windriver.com>
In-Reply-To: <1267420188-10227-1-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2010 02:14:25.0103 (UTC) FILETIME=[3A3D4DF0:01CAC89C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2010 11:09 PM, Jason Wessel wrote:
> Linus please pull the kdb-merge tree which merges the kdb front end
> into the kernel debug core for 7 architectures.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git kdb-merge
>   

What is the status of this pull request?  Was some part of the process
missed here that there has been no response on this pull request?

Please let me know what is wrong here.   I have a number of other fixes
pending to the tree at this point.

Would it be possible to merge part of the tree that is only related to
kgdb, in particular the directory re-organization?

Thanks,
Jason.
