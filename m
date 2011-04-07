Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab1DGSbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 14:31:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754793Ab1DGSbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 14:31:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110407181523.GC21838@one.firstfloor.org>
References: <cover.1302137785.git.luto@mit.edu> <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu>
 <BANLkTi=RkeFMpcb36RrJ=+eYm-xk4B2zYw@mail.gmail.com> <20110407164245.GA21838@one.firstfloor.org>
 <BANLkTikdn+Y2pWoLH_=Q4xHTgT6XGfOuSg@mail.gmail.com> <20110407181523.GC21838@one.firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Apr 2011 11:30:47 -0700
Message-ID: <BANLkTikhG9deEo0VvrUSXzn850GjBvYtiw@mail.gmail.com>
Subject: Re: [RFT/PATCH v2 2/6] x86-64: Optimize vread_tsc's barriers
To: Andi Kleen <andi@firstfloor.org>
Cc: Andy Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 11:15 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> I would prefer to be safe than sorry.

There's a difference between "safe" and "making up theoretical
arguments for the sake of an argument".

If Intel _documented_ the "barriers on each side", I think you'd have a point.

As it is, we're not doing the "safe" thing, we're doing the "extra
crap that costs us and nobody has ever shown is actually worth it".

                               Linus
