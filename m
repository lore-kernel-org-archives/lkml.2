Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab0HQInD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:43:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:47866 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab0HQInB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:43:01 -0400
Subject: Re: [PATCH] Fixed a mismatch between the users of radix_tree and
 the implementation.
From: Peter Zijlstra <peterz@infradead.org>
To: Salman Qazi <sqazi@google.com>
Cc: paulmck@us.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, adurbin@google.com,
        Nick Piggin <npiggin@gmail.com>
In-Reply-To: <AANLkTimk_16nz2BWB42yHAAseaEJP-DBdondBO5oznrQ@mail.gmail.com>
References: <20100816182834.3541.42317.stgit@bumblebee1.mtv.corp.google.com>
	 <1281987236.1926.1895.camel@laptop>
	 <AANLkTindpUo5tPiXVp6wXjOAqczrJvYegrOMBqSjr4_t@mail.gmail.com>
	 <1281992801.1926.2019.camel@laptop>
	 <AANLkTikDHG7Xo2hrrwxp1DYgGNbV6BXipY+p_Uo50498@mail.gmail.com>
	 <AANLkTimk_16nz2BWB42yHAAseaEJP-DBdondBO5oznrQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 17 Aug 2010 10:42:51 +0200
Message-ID: <1282034571.1926.2143.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 21:45 -0700, Salman Qazi wrote:
> But considering that the kernel locks up, and we are still talking
> about < 5MB after a kernel compile, should we really be all that
> concerned?  If so, what are the alternatives that should be considered
> for fixing this lock up? 

No bright ideas atm, but yeah, that indirect pointer vs rcu slot lookup
is funky. Lets go with your patch for now.

Maybe Nick has a bright idea?
