Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab1FGMNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:13:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64872 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab1FGMNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:13:42 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=auj7d2cZCtoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=t52j4xFPsvk137C7FXEA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][GIT PULL] slob/lockdep: Fix gfp flags passed to lockdep
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
        Paul Mundt <lethal@linux-sh.org>, Nick Piggin <npiggin@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110607115137.GA25798@elte.hu>
References: <1307369665.31814.20.camel@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.1106062106580.22635@chino.kir.corp.google.com>
	 <BANLkTikmp5CFKykBXaPUP0SBZEto1idDsA@mail.gmail.com>
	 <20110607101948.GB21356@elte.hu>
	 <1307445322.31814.23.camel@gandalf.stny.rr.com>
	 <20110607115137.GA25798@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Jun 2011 08:13:40 -0400
Message-ID: <1307448820.9218.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 13:51 +0200, Ingo Molnar wrote:

> Pekka could pull it as well, since you've already tested that tree 
> :-)
> 
> I don't think this tree includes any other commits, right?
> 

Nope, it was based off of commit:

5db1256a5131d3b133946fa02ac9770a784e6eb2

which is already in Linus's tree, and has just this one commit.

-- Steve


