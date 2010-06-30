Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0F3Jd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:33:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003Ab0F3Jd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:33:27 -0400
Date: Wed, 30 Jun 2010 12:32:51 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Beulich <JBeulich@novell.com>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, jeremy.fitzhardinge@citrix.com,
       Ky Srinivasan <KSrinivasan@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4, v2] x86: enlightenment for ticket spin locks -
 base implementation
Message-ID: <20100630093251.GW4689@redhat.com>
References: <4C2A1FE902000078000089E1@vpn.id2.novell.com>
 <1277885133.1868.71.camel@laptop>
 <1277889996.1868.106.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277889996.1868.106.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 11:26:36AM +0200, Peter Zijlstra wrote:
> On Wed, 2010-06-30 at 10:05 +0200, Peter Zijlstra wrote:
> > > +config ENLIGHTEN_SPINLOCKS
> > 
> > Why exactly are these enlightened? 
> 
> Or did I just miss a terribly pun:
>   enlightenment -> Buddha -> Zen -> Xen ?
Enlightenment is also a term that MS uses to describe their PV guests
which makes this name very confusing in Xen context. When I saw this
patch series I thought it has something to do with Hyper-V.

--
			Gleb.
