Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab1CIKDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 05:03:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757123Ab1CIKDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 05:03:03 -0500
Date: Wed, 9 Mar 2011 21:02:51 +1100
From: NeilBrown <neilb@suse.de>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: MD-raid broken in 2.6.37.3?
Message-ID: <20110309210251.744ef954@notabene.brown>
In-Reply-To: <20110309090622.GA3570@localhost>
References: <20110309090622.GA3570@localhost>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Mar 2011 10:06:22 +0100 Johan Hovold <jhovold@gmail.com> wrote:

> Hi Greg and Neil,
> 
> I updated from 2.6.37.2 to 2.6.37.3 yesterday only to find that my
> raid-0 partitions are no longer recognised. The raid-1 ones still are,
> though. They did not show up after a reboot. (It has happened once
> fairly recently that these exact partitions were not recognised but a
> reboot fixed it -- blamed my disks.)
> 
> Today I mistakenly booted into 2.6.37.3 again -- still missing. No
> problems with 2.6.37.2.
> 
> Browsing the changelog I found f663ed60892c3e1d4490b079a45d9e546271c40c
> (md: Fix - again - partition detection when array becomes active) and
> other md-related changes so I figure one of these could perhaps be to
> blame?
> 
> As it is my personal/production machine I feel uncomfortable bisecting
> this at this point, but maybe Neil has an idea of what might be going
> on?

Hi Johan,

 could you please be a bit more specific about the problem that you
experienced.
What, exactly, was "no longer recognised"?

Was it that the array (e.g. /dev/md1) didn't appear, or was it that the
array did appear, but that it has a partition table, and the partitions
(e.g. /dev/md1p1, /dev/md1p2) did not appear?

If you still have the boot-log from when you booted 2.6.37.3 (or can
recreated) and can get a similar log for 2.6.37.2, then it might be useful to
compare them.

Thanks,
NeilBrown
