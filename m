Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab1HEU1C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 16:27:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57486 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1HEU1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 16:27:00 -0400
Date: Fri, 5 Aug 2011 22:26:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, luto@mit.edu, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com
Subject: Re: New vsyscall emulation breaks JITs
Message-ID: <20110805202656.GI5782@one.firstfloor.org>
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3C5154.2050307@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have to say I believe that trying to JIT the vdso or vsyscall pages is
> extremely dubious at best.  They are fundamentally different from normal
> user space in that the kernel can muck with them any time, without
> notifying userspace about it.  The other aspect of this is that this is
> about the legacy vsyscall page, which we're trying to get rid of, partly
> because of security problems.

There's clear evidence now you can't: it's used even by new binaries.

-Andi

