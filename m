Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab1E0PB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:01:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:49116 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab1E0PB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:01:26 -0400
Subject: Re: [PATCH 7/7] Intel pci: Indicate 64-bit IOMMU passthrough
 available
From: David Woodhouse <dwmw2@infradead.org>
To: Mike Travis <travis@sgi.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Habeck <habeck@sgi.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dimitri Sivanich <sivanich@sgi.com>
Date: Fri, 27 May 2011 16:01:01 +0100
In-Reply-To: <20110527013222.261166889@gulag1.americas.sgi.com>
References: <20110527013221.231071058@gulag1.americas.sgi.com>
	 <20110527013222.261166889@gulag1.americas.sgi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306508463.2029.123.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 20:32 -0500, Mike Travis wrote:
>     Prior to these IOMMU patches, the passthrough option
>     could not be used because it would cause the kernel to
>     panic. 

Could not be used on certain hardware? In certain configurations? It
wasn't just *completely* broken (unless it got broken in a recent
regression).

>  Provide an indication that a kernel is capable
>     of handling passthrough mode through the introduction
>     of a specific variable name.  This allows automatic
>     configuration utilities to set the "iommu=pt" kernel
>     cmdline option safely. 

That implies that there is a follow-up patch to somehow export this
information to userspace? Where the information in question is just the
fact that a certain set of bugs have been fixed?

Since these *are* actually bugs, and not new features, I take it we're
looking at merging them for 2.6.40? I was planning to ask Linus to pull
my tree today, and I'm not entirely happy with merging them at the last
minute.

So I'll plan to merge them into my tree after the outstanding merge, and
then perhaps ask Linus to take them *after* -rc1? Since they're actually
bug fixes, I suspect that's the best way to proceed?

-- 
dwmw2

