Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab1CJIT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:19:28 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:52358 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab1CJITY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:19:24 -0500
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Mar 2011 03:19:23 EST
Date: Thu, 10 Mar 2011 10:19:21 +0200
From: Alexander Shishkin <virtuoso@slind.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Ken MacLeod <ken@bitsko.slc.ut.us>,
        Shaun Reich <predator106@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock
 changes
Message-ID: <20110310081921.GC11410@shisha.kicks-ass.net>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org>
 <20110309162513.5058c824.akpm@linux-foundation.org>
 <AANLkTinZioShsr3O0Z=xaEQ-S=JBCgs_SS_LdsBnNhZ2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinZioShsr3O0Z=xaEQ-S=JBCgs_SS_LdsBnNhZ2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 01:36:18AM +0100, Kay Sievers wrote:
> On Thu, Mar 10, 2011 at 01:25, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, š9 Mar 2011 16:36:51 +0200
> > Alexander Shishkin <virtuoso@slind.org> wrote:
> >
> >> Changes since v3:
> >> š- changed timerfd_settime() semantics (see below)
> >> Changes since v2:
> >> š- replaced sysfs interface with a syscall
> >> š- added sysctl/procfs handle to set a limit to the number of users
> >> š- fixed issues pointed out by Greg.
> >> Changes since v1:
> >> š- updated against 2.6.36-rc1,
> >> š- added notification/filtering options,
> >> š- added Documentation/ABI/sysfs-kernel-time-notify interface description.
> 
> > It would be helpful to know if the identified users of this feature
> > actually find it useful and adequate. šI guess the most common
> > application is the 1,001 desktop clock widgets. šDo you have any
> > feedback from any of the owners of those?
> 
> We want it for systemd, to provide cron-like functionality but without
> the need to stupidly wake up every minute and check the system time
> for possible jumps.
> 
> It also sounds useful for a generic resume (after system suspend)
> notification for applications, which isn't really possible today.

Yes, but with John's CLOCK_BOOTTIME patches (which are in the tip tree
currently) it will be.

Regards,
--
Alex
