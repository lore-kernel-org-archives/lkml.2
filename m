Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2GQB5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 21:57:17 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:32773 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab2GQB5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 21:57:16 -0400
Date: Mon, 16 Jul 2012 18:57:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, arjan@linux.intel.com,
        Cong Wang <xiyou.wangcong@gmail.com>, JBottomley@parallels.com
Subject: Re: [PATCH RESEND] Fix a dead loop in async_synchronize_full()
Message-ID: <20120717015710.GA2438@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1341817465.4579.5.camel@ThinkPad-T420>
 <20120711154232.165cbca9.akpm@linux-foundation.org>
 <CABE8wwsqyo=BPCy4xy1PAVKFWe=GqYRdYowXkQ6UZoXdtEdCZA@mail.gmail.com>
 <1342086988.4091.44.camel@ThinkPad-T420>
 <alpine.DEB.2.01.1207161130080.26923@trent.utfs.org>
 <CAA9_cmf-5CW0KW=721Hh3GCKGgQYsJo1UX3AFbG+7c4fTGw-Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmf-5CW0KW=721Hh3GCKGgQYsJo1UX3AFbG+7c4fTGw-Yw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071701-7606-0000-0000-0000020E72BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 04:01:33PM -0700, Dan Williams wrote:
> On Mon, Jul 16, 2012 at 11:32 AM, Christian Kujau <lists@nerdbynature.de> wrote:
> > Is this still scheduled to go into 3.5? I'm asking because -rc7 has been
> > released and does not contain this fix. W/o this fix, my powerpc system
> > won't boot[0] :-\
> 
> I don't expect James is going to push my async changes for 3.5.  So
> maybe we should go with Zhong's smaller fix for 3.5 and then replace
> with the ASYNC_DOMAIN patches in 3.6?

Makes sense to me!  I have been using Zhong's fix for my testing on
PowerPC for some weeks now with no trouble.

							Thanx, Paul

