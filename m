Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab1AYKEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:04:15 -0500
Received: from service87.mimecast.com ([94.185.240.25]:35688 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752017Ab1AYKEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:04:14 -0500
Subject: Re: [PATCH v4 08/19] ARM: LPAE: Introduce the 3-level page table
 format definitions
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nick Piggin <npiggin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110124214225.GO24104@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
	 <1295891761-18366-9-git-send-email-catalin.marinas@arm.com>
	 <AANLkTi=d0q0Upde3=b4tpu3icOr4XdifcFRvBHuXgsBN@mail.gmail.com>
	 <20110124214225.GO24104@n2100.arm.linux.org.uk>
Organization: ARM Limited
Date: Tue, 25 Jan 2011 10:04:02 +0000
Message-ID: <1295949842.10109.16.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 25 Jan 2011 10:04:07.0293 (UTC) FILETIME=[3430BAD0:01CBBC77]
X-MC-Unique: 111012510041102101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 21:42 +0000, Russell King - ARM Linux wrote:
> On Tue, Jan 25, 2011 at 08:26:42AM +1100, Nick Piggin wrote:
> > On Tue, Jan 25, 2011 at 4:55 AM, Catalin Marinas
> > <catalin.marinas@arm.com> wrote:
> > > This patch introduces the pgtable-3level*.h files with definitions
> > > specific to the LPAE page table format (3 levels of page tables).
> >
> > Seeing as you're shaking up these definitions, what do you think about
> > switching from 4level-fixup.h to pgtable-nopud.h / pgtable-nopmd.h headers?
> > One day eventually it would be nice to get rid of the fixup mode.
> 
> I have patches to do this which I de-queued for the last merge window.
> It's not entirely trivial and without problem.  You can find the patches
> in linux-next now.
> 
> I was waiting for the new set of patches from Catalin before going back
> and working out the solutions to some of those problems.

I'm fine with going this route but I haven't had time to review your
patches yet (have they been posted to the list, I've been busy lately
and haven't followed everything).

Thanks.

-- 
Catalin


