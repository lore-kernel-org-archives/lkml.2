Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab1FDNEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 09:04:23 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54313 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770Ab1FDNEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 09:04:22 -0400
Date: Sat, 4 Jun 2011 09:04:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-06-03
Message-ID: <20110604130413.GA3929@tuxdriver.com>
References: <20110603195254.GF2509@tuxdriver.com>
 <BANLkTimoeVDQK+zu=U+nSM_kj0a3-hh_Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimoeVDQK+zu=U+nSM_kj0a3-hh_Jg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 11:24:49PM +0200, Rafał Miłecki wrote:
> On Jun 3, 2011 10:03 PM, "John W. Linville" <linville@tuxdriver.com> wrote:
> >
> > Dave,
> >
> > Here is a batch of fixes intended for 3.0 -- I guess I'll need to
> > rename my tree eventually... :-)
> >
> > Included are a libertas fix to ensure proper sequence number assignment
> > on transmitted frames, an ath9k fix that propogates an earlier fix to a
> > few more places,  a fix for a cfg80211 regression caused by some mesh
> > code changes, a locking fix for the bluetooth l2cap code, a zd1211rw
> > regression fix, a collection of small fixes for wl12xx, an iwl4965
> > fix for a bad temperature check, an a device ID-related fix for iwlagn.
> >
> > Please let me know if there are problems!
> 
> John, you didn't.take my fix for regression in ssb. I really want this for
> 3.0.quickly, as few ppl already had problems with machine locking on boot.

Yours isn't the only fix, and I had quite a few queued already.  Patience.

-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
