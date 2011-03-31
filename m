Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445Ab1CaWuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 18:50:23 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56300 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab1CaWuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 18:50:21 -0400
Date: Thu, 31 Mar 2011 15:50:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, dave@gnu.org, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:x86/urgent] x86, mce: Fix RCU lockdep from mce_poll()
Message-ID: <20110331225016.GM2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1301537604.2140.21.camel@offworld>
 <tip-706453b0d1fabf4dccbcffa29356d0dd6ab9afb9@git.kernel.org>
 <AANLkTi=wZMCS_j+VAb4BpBJvoeh_cQpWVXgpdJ-tEmXN@mail.gmail.com>
 <20110331164107.GH2258@linux.vnet.ibm.com>
 <AANLkTikEtEee+HibSfy7mF4MB_7uUz+H8xVfwTFC49xV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikEtEee+HibSfy7mF4MB_7uUz+H8xVfwTFC49xV@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 11:32:20PM +0200, Zdenek Kabelac wrote:
> 2011/3/31 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > On Thu, Mar 31, 2011 at 12:03:48PM +0200, Zdenek Kabelac wrote:

[ . . . ]

> > +/**
> >  * rcu_dereference_index_check() - rcu_dereference for indices with debug checking
> >  * @p: The pointer to read, prior to dereferencing
> >  * @c: The conditions under which the dereference will take place
> >
> 
> Works for me.
> 
> Tested-by: Zdenek Kabelac <zkabelac@redhat.com>

Thank you, Zdenek!

Andi, did you want to carry this patch, or would you prefer that I did so?
If the latter, could you please revert the busted patch?

							Thanx, Paul
