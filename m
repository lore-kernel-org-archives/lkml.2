Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab0C2SlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:41:05 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50615 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab0C2SlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:41:01 -0400
Date: Mon, 29 Mar 2010 11:40:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PROVE_RCU breaks proprietary modules (rcu_lock_map)
Message-ID: <20100329184059.GL2569@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BA689EA.4050102@imap.cc>
 <20100329150946.GB2569@linux.vnet.ibm.com>
 <4BB0E937.7070200@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB0E937.7070200@imap.cc>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 07:53:59PM +0200, Tilman Schmidt wrote:
> Am 29.03.2010 17:09 schrieb Paul E. McKenney:
> > On Sun, Mar 21, 2010 at 10:04:42PM +0100, Tilman Schmidt wrote:
> [...]
> >> So if building a proprietary module fails with the message:
> >>
> >> FATAL: modpost: GPL-incompatible module <module> uses GPL-only symbol
> >> 'rcu_lock_map'
> >>
> >> try rebuilding your kernel with the PROVE_RCU option disabled.
> >>
> >> Hope it helps someone.
> > 
> > I am comfortable with PROVE_RCU being incompatible with non-GPL modules.
> > After all, it is only a debugging option, not intended for production use.
> 
> I agree completely. I just wanted to publish that fact because it seems
> to be little known and can be quite a puzzler.

And I do very much appreciate your publicizing the solution!  ;-)

						Thanx, Paul
