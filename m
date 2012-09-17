Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab2IQJ3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:29:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46391 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2IQJ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:29:13 -0400
Message-ID: <5056ED66.30203@monstr.eu>
Date: Mon, 17 Sep 2012 11:29:10 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] status of execve() work - per-architecture patches solicited
References: <20120907182004.GE13973@ZenIV.linux.org.uk>
In-Reply-To: <20120907182004.GE13973@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On 09/07/2012 08:20 PM, Al Viro wrote:
> 	To architecture maintainers: please, review the current
> situation in git.kernel.org/pub/scm/linux/kernel/git/viro/signal #execve2
> and consider sending the corresponding patches for missing architectures.

I have sent two patches. Please apply them to your tree.

Michal Simek (2):
       microblaze: Move restart allowed out of block
       microblaze: Remove compilation failure

  arch/microblaze/kernel/entry.S |    6 +++---
  1 files changed, 3 insertions(+), 3 deletions(-)

I have seen the compilation problem in June on linux-next but
have never got any response from you.
http://www.spinics.net/lists/linux-next/msg20848.html

Can you please apply these two patches to your tree?

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
