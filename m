Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab2BZNLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 08:11:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46394 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab2BZNLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 08:11:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.125.227 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Sun, 26 Feb 2012 05:10:31 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Maciej Rutecki <maciej.rutecki@gmail.com>
cc: Jiri Slaby <jslaby@suse.cz>, n-horiguchi@ah.jp.nec.com,
        kamezawa.hiroyu@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
        linux-mm@kvack.org
Subject: Re: Regression: Bad page map in process xyz
In-Reply-To: <201202261027.48029.maciej.rutecki@gmail.com>
Message-ID: <alpine.LSU.2.00.1202260502450.5648@eggly.anvils>
References: <4F421A29.6060303@suse.cz> <201202261027.48029.maciej.rutecki@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1891972638-1330261843=:5648"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1891972638-1330261843=:5648
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 26 Feb 2012, Maciej Rutecki wrote:
> On poniedzia=C5=82ek, 20 lutego 2012 o 11:02:17 Jiri Slaby wrote:
> > Hi,
> >=20
> > I'm getting a ton of
> > BUG: Bad page map in process zypper  pte:676b700029736c6f pmd:44967067
> > when trying to upgrade the system by:
> > zypper dup
> >=20
> > I bisected that to:
> > commit afb1c03746aa940374b73a7d5750ee05a2376077
> > Author: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > Date:   Fri Feb 17 10:57:58 2012 +1100
> >=20
> >     thp: optimize away unnecessary page table locking
> >=20
> > thanks,
>=20
> I created a Bugzilla entry at=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D42820
> for your bug/regression report, please add your address to the CC list in=
=20
> there, thanks!

No, thanks for spotting it, but please remove from the regressions
report: it's not a regression in 3.3-rc but in linux-next - don't take
my word for it, check the commit and you'll not find it in 3.3-rc.

We do still need to get the fix into linux-next: Horiguchi-san, has
akpm put your fix in mm-commits yet?  Please send it again if not.

Hugh
--8323584-1891972638-1330261843=:5648--
