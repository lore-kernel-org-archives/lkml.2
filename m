Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab0IWOFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:05:18 -0400
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:51977 "EHLO
	homiemail-a1.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755352Ab0IWOFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:05:17 -0400
Subject: Re: [PATCH] kmemleak: add unlikely() optimization to
 kmemleak_late_init
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <tnxlj6uhz2s.fsf@e102109-lin.cambridge.arm.com>
References: <1285089797.2177.2.camel@cowboy>
	 <tnxlj6uhz2s.fsf@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 10:05:12 -0400
Message-ID: <1285250712.2127.1.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 11:06 +0100, Catalin Marinas wrote:
> Davidlohr Bueso <dave@gnu.org> wrote:
> > kmemleak: add unlikely() optimization to kmemleak_late_init()
> >
> > Since there it is not very probable that kmemleak_disable() was called right after setting kmemleak_initialized, we could benefit from predicting it.
> 
> The patch is correct and you can add my Acked-by but I don't really
> think it's worth. We save ~2 cycles during booting, no-one would ever
> notice.
> 

Yeah, it's not a big performance booster, but IMHO it wouldn't hurt to
add it. Since you are the maintainer it's up to you if you include it
upstream.

Thanks,
Davidlohr

