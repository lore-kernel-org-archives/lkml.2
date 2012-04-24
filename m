Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab2DXVvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:51:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:52258 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab2DXVve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:51:34 -0400
Message-ID: <1335304283.28150.240.camel@twins>
Subject: Re: [RFC][PATCH 0/3] gcc work-around and math128
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>
Date: Tue, 24 Apr 2012 23:51:23 +0200
In-Reply-To: <CALCETrWJvQ6h=YaPX20pTGLQ39m1aFNEuubTb9f3cJczDPWy-g@mail.gmail.com>
References: <20120424161039.293018424@chello.nl>
	 <4F9717E6.8030506@amacapital.net> <1335303177.28150.235.camel@twins>
	 <CALCETrWJvQ6h=YaPX20pTGLQ39m1aFNEuubTb9f3cJczDPWy-g@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 14:35 -0700, Andy Lutomirski wrote:
> Yeesh.  That looks way slower.

Indeed, pulled it through gcc and saw what was generated with
mult_frac :/
