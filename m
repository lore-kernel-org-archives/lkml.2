Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab0KKD7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 22:59:11 -0500
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:14974 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932256Ab0KKD7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 22:59:10 -0500
From: Bruno Randolf <br1@einfach.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v6] Add generic exponentially weighted moving average (EWMA) function
Date: Thu, 11 Nov 2010 12:59:22 +0900
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: randy.dunlap@oracle.com, peterz@infradead.org, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        kosaki.motohiro@jp.fujitsu.com, kevin.granade@gmail.com
References: <20101111034756.15014.2156.stgit@localhost6.localdomain6> <20101110195329.d456e29b.akpm@linux-foundation.org>
In-Reply-To: <20101110195329.d456e29b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011111259.22717.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu November 11 2010 12:53:29 Andrew Morton wrote:
> On Thu, 11 Nov 2010 12:47:56 +0900 Bruno Randolf <br1@einfach.org> wrote:
> > This adds generic functions for calculating Exponentially Weighted Moving
> > Averages (EWMA). This implementation makes use of a structure which keeps
> > the EWMA parameters and a scaled up internal representation to reduce
> > rounding errors.
> > 
> > The original idea for this implementation came from the rt2x00 driver
> > (rt2x00link.c). I would like to use it in several places in the mac80211
> > and ath5k code and I hope it can be useful in many other places in the
> > kernel code.
> > 
> > Signed-off-by: Bruno Randolf <br1@einfach.org>
> > Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > 
> > --
> > 
> > Excuse me, but can I expect this to be merged anytime soon? Where do I
> > check if it got merged? I'm resending the patch in case it got lost.
> 
> Yes, sorry, this is buried in my exponentially increasing backlog.
> It's going to take me a while to catch up again.

I don't mean to be pushy, so please take your time...

bruno
