Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0HNBCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 21:02:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62662 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab0HNBCw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 21:02:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bd8VJO6613cY95IDLATdGpdbHq05kAYMEVMxERUufaNgRcRdRTbAf+YdZ0BLnhaD8O
         DquZ3QHKh3hd8D+jZ5im98+AYTLvEYnEgPpgy80XevZPqdAPjy3XsV97jlALvBJd5Hhc
         7L6uFO9haw1E+o9TKzT8l5WD0nv2hk501UOAU=
MIME-Version: 1.0
In-Reply-To: <201008140039.o7E0dqTq005996@farm-0002.internal.tilera.com>
References: <AANLkTikvJna6vnc73RVhVAJZ8mERJoFk=V6Nwq-3HHWz@mail.gmail.com> <201008140039.o7E0dqTq005996@farm-0002.internal.tilera.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 13 Aug 2010 21:02:31 -0400
Message-ID: <AANLkTinUtn9noO-UwNSkNnb94OaQuK-x8-okSQDiD++4@mail.gmail.com>
Subject: Re: [PATCH] arch/tile: Rename the hweight() implementations to __arch_hweight().
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 20:32, Chris Metcalf wrote:
> Mike, thanks for the pointer to the hweight issue.  Since we are using
> __builtin_popcount() and the compiler can do constant propagation, etc.,
> with it at compile-time, this is less critical, but it seems like the
> easiest way to get the definitions of the HWEIGHT macros.

interesting ... i wasnt aware of the popcount builtin.  the Blackfin
ISA has a "ONES" insn which does this.  guess we should implement the
popcount builtin too.
-mike
