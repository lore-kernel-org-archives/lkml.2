Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab0H0UWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 16:22:53 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48949 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0H0UWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 16:22:50 -0400
Date: Fri, 27 Aug 2010 15:22:50 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Roberto Oppedisano <roberto.oppedisano@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, ecryptfs-devel@lists.launchpad.net,
        ecryptfs-users@lists.launchpad.net
Subject: Re: regression: ecryptfs broken on 2.6.36-rc2 (x86_64)
Message-ID: <20100827202249.GA23972@boomer>
References: <4C735DC7.7090308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C735DC7.7090308@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue Aug 24, 2010 at 07:51:03AM +0200, Roberto Oppedisano <roberto.oppedisano@gmail.com> wrote:
>  I'm having the very same problem reported from another ecryptfs user.
> 
> https://bugs.launchpad.net/ecryptfs/+bug/623087
> 
> In short permissions seem to be broken on ecryptfs mounts, and ls
> output looks like:
> 
> ls: cannot access enctest/file1: No such file or directory
> ls: cannot access enctest/sub: No such file or directory
> total 12
> 545077 -????????? ? ? ? ? ? file1
> 545075 -rw-r--r-- 1 root root 3 2010-08-24 08:53 file3-2.6.36
> 545078 d????????? ? ? ? ? ? sub
> 
> Everything was fine in 2.6.35.
> 

A fix for this regression should be merged by 2.6.36-rc3. Until then,
you can get the patch from:

http://git.kernel.org/?p=linux/kernel/git/ecryptfs/ecryptfs-2.6.git;a=commit;h=93c3fe40c279f002906ad14584c30671097d4394

For those interested, the bug report linked above has a description
of the problem. In general, you shouldn't use eCryptfs in 2.6.36-rc{1,2}
if you have file name encryption enabled.

Tyler

