Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab0ITUlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:41:02 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36329 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757448Ab0ITUk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:40:59 -0400
Date: Mon, 20 Sep 2010 13:40:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michael Cree <mcree@orcon.net.nz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, James.Bottomley@HansenPartnership.com,
        benh@kernel.crashing.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: memory barrier question
Message-ID: <20100920204055.GJ2408@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100917231222.GA3060@linux.vnet.ibm.com>
 <1284864421.30449.113.camel@pasglop>
 <20100919152638.GF3060@linux.vnet.ibm.com>
 <E1OxQIg-0005Nw-WE@pomaz-ex.szeredi.hu>
 <20100919215909.GG3060@linux.vnet.ibm.com>
 <1284944316.2957.795.camel@mulgrave.site>
 <20100920012915.GI3060@linux.vnet.ibm.com>
 <E1OxioY-0006nd-M9@pomaz-ex.szeredi.hu>
 <20100920182504.GD2408@linux.vnet.ibm.com>
 <4C97C366.80206@orcon.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C97C366.80206@orcon.net.nz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 08:26:14AM +1200, Michael Cree wrote:
> On 21/09/10 06:25, Paul E. McKenney wrote:
> >But do we really care about Alpha anymore?  (I can see it now... The
> >Alpha portion of the kernel tree moves to staging...)
> 
> I do.
> 
> Sent from my Compaq Alpha XP1000 :-)

In that case, an smp_read_barrier_depends() or rcu_dereference() is
also required...

							Thanx, Paul
