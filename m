Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2B0EqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 23:46:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab2B0EqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 23:46:14 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Hugh Dickins <hughd@google.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        n-horiguchi@ah.jp.nec.com, kamezawa.hiroyu@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
        linux-mm@kvack.org
Subject: =?UTF-8?q?Re=3A=20Regression=3A=20Bad=20page=20map=20in=20process=20xyz?=
Date: Sun, 26 Feb 2012 23:45:33 -0500
Message-Id: <1330317933-20196-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <alpine.LSU.2.00.1202260502450.5648@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Sun, Feb 26, 2012 at 05:10:31AM -0800, Hugh Dickins wrote:
> On Sun, 26 Feb 2012, Maciej Rutecki wrote:
> > On poniedziaナＦk, 20 lutego 2012 o 11:02:17 Jiri Slaby wrote:
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

Sorry for late reply.
And yes, this fix is in mm-commits now.

Thanks,
Naoya
