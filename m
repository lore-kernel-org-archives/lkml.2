Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497Ab0HENls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 09:41:48 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38185 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab0HENlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 09:41:39 -0400
Date: Thu, 5 Aug 2010 14:40:57 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100805134057.GB20565@srcf.ucam.org>
References: <20100801054816.GI2470@linux.vnet.ibm.com> <20100804205654.GA4986@srcf.ucam.org> <AANLkTi=fH=XqJ0QgaMwPr5efacWAFo5h0khD7RjL4n8L@mail.gmail.com> <201008050220.51805.rjw@sisk.pl> <AANLkTikK+OCrg8Jx5SpTbg6iFDX12MKZrTsdOr4mRJN0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikK+OCrg8Jx5SpTbg6iFDX12MKZrTsdOr4mRJN0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 06:02:28PM -0700, Arve Hjønnevåg wrote:

> Which makes the driver and/or network stack changes identical to using
> wakelocks, right?

I think we're resigned to the fact that we need to indicate wakeup 
events in a manner that's pretty equivalent to wakelocks. The only real 
issue is what the API looks like. Anyone who's still talking about 
cgroups seems to be trying to solve a different problem.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
