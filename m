Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab0ICImR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:42:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab0ICImO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:42:14 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>, gerg@snapgear.com,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] M68K: Use CONFIG_MMU not __uClinux__ to select m68knommu contributions
References: <19747.1283422807@redhat.com>
	<20100902102158.19806.14133.stgit@warthog.procyon.org.uk>
	<m38w3kns4r.fsf@hase.home>
	<AANLkTikwax-Jb60jT5_TOL=Zkwbgh8FwMk78ncm1dN-P@mail.gmail.com>
X-Yow: QUIET!!  I'm being CREATIVE!!  Is it GREAT yet?  It's s'posed to
 SMOKEY THE BEAR...
Date: Fri, 03 Sep 2010 10:41:51 +0200
In-Reply-To: <AANLkTikwax-Jb60jT5_TOL=Zkwbgh8FwMk78ncm1dN-P@mail.gmail.com>
	(Geert Uytterhoeven's message of "Thu, 2 Sep 2010 21:53:53 +0200")
Message-ID: <m3vd6nmd68.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On Thu, Sep 2, 2010 at 16:21, Andreas Schwab <schwab@redhat.com> wrote:
>> David Howells <dhowells@redhat.com> writes:
>>
>>> Use CONFIG_MMU not __uClinux__ to select m68knommu contributions as nothing in
>>> the arch defines __uClinux__ for the build.
>>
>> You are using the wrong compiler.
>
> it would be nice if you could use the same compiler for m68k and m68knommu, at
> least for compiling kernels.

You are almost able to use the uclinux compiler for both, except that
currently __uClinux__ is hardcoded.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
