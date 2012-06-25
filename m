Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab2FYTxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 15:53:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab2FYTxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 15:53:13 -0400
Date: Mon, 25 Jun 2012 15:52:48 -0400
From: Dave Jones <davej@redhat.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Johannes Stezenbach <js@sig21.net>, Thomas Gleixner <tglx@linutronix.de>,
        Marc Dionne <marc.c.dionne@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: NOHZ: local_softirq_pending 08
Message-ID: <20120625195248.GA23220@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Francois Romieu <romieu@fr.zoreil.com>,
	Johannes Stezenbach <js@sig21.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Dionne <marc.c.dionne@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	David Miller <davem@davemloft.net>
References: <20120606054251.GA24467@electric-eye.fr.zoreil.com>
 <20120608023420.GD7191@redhat.com>
 <alpine.LFD.2.02.1206080954440.3086@ionos>
 <20120608142333.GB1711@redhat.com>
 <alpine.LFD.2.02.1206081641040.3086@ionos>
 <20120608202701.GA26175@electric-eye.fr.zoreil.com>
 <alpine.LFD.2.02.1206082238120.3086@ionos>
 <20120608215328.GB26175@electric-eye.fr.zoreil.com>
 <20120625123809.GA12623@sig21.net>
 <20120625192839.GA20195@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120625192839.GA20195@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 09:28:39PM +0200, Francois Romieu wrote:
 > Johannes Stezenbach <js@sig21.net> :
 > [7dbb491878a2c51d372a8890fa45a8ff80358af1]
 > > I just upgraded my rarely-used Atom based netbook from 3.3.5 to 3.4.4
 > > and got the "NOHZ: local_softirq_pending 08" message.
 > > Should this patch go into stable?
 > 
 > It should not change your life. I'll be fine with whatever policy davej,
 > tglx or davem see fit (assuming they share one :o) ).

it never seemed to cause any noticable problem that I observed (just the dmesg spew),
so I'm ambivalent about the whole thing now that it's fixed in 3.5rc :-)

	Dave 
