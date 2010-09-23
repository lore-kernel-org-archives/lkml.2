Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab0IWPCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:02:20 -0400
Received: from xenotime.net ([72.52.115.56]:36947 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752938Ab0IWPCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:02:19 -0400
Date: Thu, 23 Sep 2010 08:02:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Any SYSRQ key to force mode switch to console mode when using
 KMS?
Message-Id: <20100923080212.ca4be1f6.rdunlap@xenotime.net>
In-Reply-To: <19611.20403.865248.695829@elektron.ikp.physik.tu-darmstadt.de>
References: <19601.1301.803816.92851@elektron.ikp.physik.tu-darmstadt.de>
	<20100921151033.80e61747.randy.dunlap@oracle.com>
	<19609.53242.674915.369484@elektron.ikp.physik.tu-darmstadt.de>
	<4C9A1FB7.9050902@oracle.com>
	<19611.8986.142128.168878@elektron.ikp.physik.tu-darmstadt.de>
	<19611.20403.865248.695829@elektron.ikp.physik.tu-darmstadt.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 15:01:39 +0200 Uwe Bonnes wrote:

> >>>>> "Uwe" == Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de> writes:
> 
> >>>>> "Randy" == Randy Dunlap <randy.dunlap@oracle.com> writes:
> ...
>     Uwe> However 2.6.36-rc4 also fixed my hibernate problem:
> 
>     Uwe> commit 84e1d836ef0759a152578a961894824bde89596f Merge: 20f4cad
>     Uwe> 6715045 Author: Linus Torvalds <torvalds@linux-foundation.org>
>     Uwe> Date: Sat Sep 11 15:50:53 2010 -0700
> 
>     Uwe>     Merge branch 'pm-fixes' of
>     Uwe> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6
>     
>     Uwe>     * 'pm-fixes' of ...  PM / Hibernate: Avoid hitting OOM during
>     Uwe> preallocation of memory ...
> 
>     Uwe> so I no longer hit the problem with the dark screen...
> 
> I burried the problem too early. 
> 
> On another hibernate attempt on 2.6.36-rc4, now the image again was not
> written to disk, the screen turn black and no ALT-CTL-SYSRQ combination
> helped. Especially I tried  ALT-CTL-SYSRQ ad 'v','V', ALT-CTL 'v' and
> ALT-CTL 'V'...

Is CONFIG_DRM_KMS_HELPER enabled in your kernel .config file?
If not, we need to find out how to enable it (there is no kconfig
prompt for it).

Can you check if Alt-Sysrq-H (help) lists V for "force-fb(V)"?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
