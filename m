Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808Ab1CaBhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 21:37:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57794 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577Ab1CaBhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 21:37:53 -0400
Date: Thu, 31 Mar 2011 03:37:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, paulmck@linux.vnet.ibm.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mce: fix RCU lockdep from mce_log()
Message-ID: <20110331013750.GJ21838@one.firstfloor.org>
References: <1288993499.2065.4.camel@cowboy> <20101106185350.GA23824@basil.fritz.box> <20101107133950.GV15561@linux.vnet.ibm.com> <1289215819.2318.3.camel@cowboy> <20101108131708.GC2580@linux.vnet.ibm.com> <AANLkTikkQ6TdNzkBb6cusFTek7_y=bM1N=+X5zmp3eYY@mail.gmail.com> <1301534041.2140.3.camel@offworld>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301534041.2140.3.camel@offworld>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm still quite interested in getting this fixed, I run into it several
> times a day.

Paul needs to send his fix to the x86 maintainers. They were not cc'ed
so never saw this.

-Andi
