Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2AWPQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:16:17 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38924 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2AWPQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:16:15 -0500
Date: Mon, 23 Jan 2012 10:10:14 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2012-01-03
Message-ID: <20120123151013.GA9474@tuxdriver.com>
References: <20120103033320.GG1472@joana>
 <20120123125655.GA20973@x220.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120123125655.GA20973@x220.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a day off today.  I'll get back to merging tomorrow, including
this request from Gustavo.

Thanks,

John

On Mon, Jan 23, 2012 at 02:56:55PM +0200, Johan Hedberg wrote:
> Hi John,
> 
> On Tue, Jan 03, 2012, Gustavo Padovan wrote:
> > A couple of fixes for the 3.3 release. The majority of the fixes are related
> > to the change from tasklets to workqueue in the Bluetooth Core. The rest are
> > important fixes over the tree. Exception is "Bluetooth: Rename extfeatures¨,
> > as the name says it is just a rename and no harm, but it is a preparation for
> > a following fix.
> > 
> > Please pull, or let me know any concerns you have!
> > 
> > 	Gustavo
> > 
> > --
> > The following changes since commit dc0d633e35643662f27a0b1c531da3cd6b204b9c:
> > 
> >   Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next (2012-01-02 16:43:54 -0500)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next master
> > 
> > Andre Guedes (5):
> >       Bluetooth: Rename extfeatures
> >       Bluetooth: Fix hci_cc_read_local_ext_features()
> >       Bluetooth: Fix adv_work delay
> >       Bluetooth: Queue adv_work on system workqueue
> >       Bluetooth: Fix mgmt_stop_discovery_failed()
> > 
> > Andrei Emeltchenko (1):
> >       Bluetooth: Correct packet len calculation
> > 
> > Gustavo F. Padovan (8):
> >       Bluetooth: Fix bacpy in l2cap_core.c
> >       Bluetooth: Fix context in rfcomm_sock_lock
> >       Bluetooth: Fix context in RFCOMM tty
> >       Bluetooth: Remove *_bh locks from SCO
> >       Bluetooth: Remove local_bh_disable() from hci_sock.c
> >       Bluetooth: Remove *_bh from socket list lock.
> >       Bluetooth: Don't use *_bh locks anymore
> >       Bluetooth: Keep chan->state and sk->sk_state in sync
> > 
> >  include/net/bluetooth/hci_core.h |    4 ++--
> >  net/bluetooth/af_bluetooth.c     |    8 ++++----
> >  net/bluetooth/hci_event.c        |   22 +++++++++++++---------
> >  net/bluetooth/hci_sock.c         |    2 --
> >  net/bluetooth/l2cap_core.c       |   26 +++++++++++++-------------
> >  net/bluetooth/l2cap_sock.c       |    2 ++
> >  net/bluetooth/mgmt.c             |    4 ++--
> >  net/bluetooth/rfcomm/sock.c      |   12 ++++++------
> >  net/bluetooth/rfcomm/tty.c       |   22 +++++++++++-----------
> >  net/bluetooth/sco.c              |    8 ++++----
> >  10 files changed, 57 insertions(+), 53 deletions(-)
> > --
> 
> Are you planing to pull this? I've been waiting for that before making
> any new pull requests from my (temporary) bluetooth-next tree[1]. If
> that's not gonna happen I'll go ahead rebase my tree against latest
> wireless-next (including these patches and all other ones that Marcel
> has acked since Gustavo started his break), and make a new pull request
> to you in the near future.
> 
> Johan
> 
> [1] http://git.kernel.org/?p=linux/kernel/git/jh/bluetooth-next.git;a=summary
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
