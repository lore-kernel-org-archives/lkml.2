Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1FKIWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 04:22:37 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:59246 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1FKIWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 04:22:34 -0400
Subject: Re: 3.0.0-rc2-git4 -- INFO: possible circular locking dependency
 detected
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <BANLkTinC43QH_iEY29_Umt87Sn3A5GGQ3A@mail.gmail.com> (sfid-20110610_223806_173548_9F7B1F62)
References: <BANLkTinC43QH_iEY29_Umt87Sn3A5GGQ3A@mail.gmail.com>
	 (sfid-20110610_223806_173548_9F7B1F62)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Jun 2011 10:22:30 +0200
Message-ID: <1307780550.4219.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [  330.762815] [ INFO: possible circular locking dependency detected ]
> [  330.762819] 3.0.0-rc2-git4 #9
> [  330.762822] -------------------------------------------------------
> [  330.762825] kworker/0:0/4 is trying to acquire lock:
> [  330.762828]  (&rdev->mtx){+.+.+.}, at: [<ffffffffa006f7e0>]
> cfg80211_netdev_notifier_call+0x275/0x4ff [cfg80211]
> [  330.762845]
> [  330.762846] but task is already holding lock:
> [  330.762848]  (&rdev->devlist_mtx){+.+.+.}, at: [<ffffffffa006fd5c>]
> cfg80211_rfkill_set_block+0x28/0x70 [cfg80211]
> [  330.762860]
> [  330.762861] which lock already depends on the new lock.

Yeah, Luca is supposed to be working on this.

johannes


