Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab1ANVYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 16:24:15 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43243 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab1ANVYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:24:12 -0500
Date: Fri, 14 Jan 2011 21:24:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Colin Cross <ccross@android.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
Message-ID: <20110114212400.GO15996@n2100.arm.linux.org.uk>
References: <20110114120229.GA15996@n2100.arm.linux.org.uk> <1295014231.7901.41.camel@e102109-lin.cambridge.arm.com> <20110114154919.GE15996@n2100.arm.linux.org.uk> <1295022193.7901.56.camel@e102109-lin.cambridge.arm.com> <20110114163520.GH15996@n2100.arm.linux.org.uk> <1295024327.7901.70.camel@e102109-lin.cambridge.arm.com> <20110114173050.GJ15996@n2100.arm.linux.org.uk> <20110114184759.GN15996@n2100.arm.linux.org.uk> <AANLkTi=J2A1Qv6NGB1bsMr6d+1VFV26KEBQ=NJ=791s0@mail.gmail.com> <AANLkTimd44_FjnJUCNwz412Ned5S_+YcyHjfitus3vLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimd44_FjnJUCNwz412Ned5S_+YcyHjfitus3vLQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 11:51:38AM -0800, Colin Cross wrote:
> On Fri, Jan 14, 2011 at 11:23 AM, Colin Cross <ccross@android.com> wrote:
> > I tested copying r2 to regs->ARM_pc like this patch does, and it fixes
> > my test case.  Could this second patch go first so it can be applied
> > to stable?
> >
> 
> Also, both patches together Tested-by: Colin Cross <ccross@android.com>

Thanks.  I do want to hear back from Catalin before merging them, so
they won't be part of tonight's push.
