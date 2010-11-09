Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab0KIT4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:56:25 -0500
Received: from smtp.outflux.net ([198.145.64.163]:53105 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab0KIT4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:56:24 -0500
Date: Tue, 9 Nov 2010 11:56:22 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86: call verify_cpu during 32bit CPU startup
Message-ID: <20101109195622.GR5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
 <20101109181525.GH5876@outflux.net>
 <AANLkTimzAaj1Z-jyCLBPKGzp_PWw2hwkYy_XeLo8CKPP@mail.gmail.com>
 <20101109191908.GO5876@outflux.net>
 <AANLkTi=zU=RxqMX_h=BM4WchgCbwTi9tWa0SkhxmDwcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=zU=RxqMX_h=BM4WchgCbwTi9tWa0SkhxmDwcg@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 09:46:39PM +0200, Pekka Enberg wrote:
> I actually don't see 0/4 or 2/4 on LKML yet. It would be better to
> have the rationale in the patch that changes the code for future
> reference. The summary email will be lost in the noise much more
> easily.

Looks like delivery delays somewhere. I see it in the archive:
http://lkml.org/lkml/2010/11/9/380

But sure, I can improve the commit messages further.

-Kees

-- 
Kees Cook
Ubuntu Security Team
