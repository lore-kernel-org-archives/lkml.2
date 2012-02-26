Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab2BZRES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 12:04:18 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64593 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab2BZREQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 12:04:16 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of maciej.rutecki@gmail.com designates 10.213.14.205 as permitted sender) smtp.mail=maciej.rutecki@gmail.com; dkim=pass header.i=maciej.rutecki@gmail.com
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Hugh Dickins <hughd@google.com>
Subject: Re: Regression: Bad page map in process xyz
Date: Sun, 26 Feb 2012 18:04:11 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc4; KDE/4.6.5; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, n-horiguchi@ah.jp.nec.com,
        kamezawa.hiroyu@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
        linux-mm@kvack.org
References: <4F421A29.6060303@suse.cz> <201202261027.48029.maciej.rutecki@gmail.com> <alpine.LSU.2.00.1202260502450.5648@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1202260502450.5648@eggly.anvils>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202261804.11440.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 26 lutego 2012 o 14:10:31 Hugh Dickins wrote:
> On Sun, 26 Feb 2012, Maciej Rutecki wrote:
> > On poniedziałek, 20 lutego 2012 o 11:02:17 Jiri Slaby wrote:
> > > Hi,
> > > 
> > > I'm getting a ton of
> > > BUG: Bad page map in process zypper  pte:676b700029736c6f pmd:44967067
> > > when trying to upgrade the system by:
> > > zypper dup
> > > 
> > > I bisected that to:
> > > commit afb1c03746aa940374b73a7d5750ee05a2376077
> > > Author: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > > Date:   Fri Feb 17 10:57:58 2012 +1100
> > > 
> > >     thp: optimize away unnecessary page table locking
> > > 
> > > thanks,
> > 
> > I created a Bugzilla entry at
> > https://bugzilla.kernel.org/show_bug.cgi?id=42820
> > for your bug/regression report, please add your address to the CC list in
> > there, thanks!
> 
> No, thanks for spotting it, but please remove from the regressions
> report: it's not a regression in 3.3-rc but in linux-next - don't take
> my word for it, check the commit and you'll not find it in 3.3-rc.
> 
> We do still need to get the fix into linux-next: Horiguchi-san, has
> akpm put your fix in mm-commits yet?  Please send it again if not.
> 
> Hugh

Thanks for the information. I should check where is commit placed before.

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
