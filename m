Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1FEAbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 20:31:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42997 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab1FEAbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 20:31:22 -0400
Date: Sun, 5 Jun 2011 02:31:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: George Spelvin <linux@horizon.com>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: How to measure enable_kernel_fpu overhead?
Message-ID: <20110605003118.GP27166@one.firstfloor.org>
References: <m2pqmts654.fsf@firstfloor.org> <20110605002323.16365.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605002323.16365.qmail@science.horizon.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 04, 2011 at 08:23:23PM -0400, George Spelvin wrote:
> > This seems to clever for its own good. Even if you come up with some
> > number on one CPU it could be completely different on another.
> > I would suggest KISS.
> 
> I don't understand.  Do you mean different CPUs of the same SMP system?
> That would be really bad...

Different CPU models. This years CPUs does this and next years that.

> on my systems, it would be easy.  But that's so obviously not useful
> that I didn't bother to mention it.

AFAIK you cannot merge anyways as anonymous, so it's moot.

-Andi
