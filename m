Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1G2Fys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 01:54:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:43194 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab1G2Fyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 01:54:47 -0400
Subject: Re: [tip:core/locking] lockdep: Fix lockdep_no_validate against
 IRQ states
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <4E322B19.3020604@cn.fujitsu.com>
References: <tip-2dp5vmpsxeraqm42kgww6ge2@git.kernel.org>
	 <4E322B19.3020604@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 29 Jul 2011 07:54:16 +0200
Message-ID: <1311918856.5890.212.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 11:38 +0800, Li Zefan wrote:
> > +             if (hlock_class(hlock)->key ==
> &__lockdep_no_validate__)
> > +                     continue;
> > +
> 
> The 2 pointers are not the same type.
> 
> kernel/lockdep.c: In function 'mark_held_locks':
> kernel/lockdep.c:2471:31: warning: comparison of distinct pointer
> types lacks a cast

Yeah, I know, I've even got a fix queued up.. Thanks though.
