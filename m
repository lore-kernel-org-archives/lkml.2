Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab1FCOEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:04:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:51262 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab1FCOEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:04:01 -0400
Subject: Re: [PATCH 0/7] Intel pci: Fix various problems with Intel IOMMU
 code
From: David Woodhouse <dwmw2@infradead.org>
To: Mike Travis <travis@sgi.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Derek Fults <dfults@sgi.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>, stable@kernel.org,
        Chris Wright <chrisw@sous-sol.org>, iommu@lists.linux-foundation.org,
        Mike Habeck <habeck@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 03 Jun 2011 15:03:44 +0100
In-Reply-To: <1306627925.2029.341.camel@i7.infradead.org>
References: <20110528181501.896092225@gulag1.americas.sgi.com>
	 <1306627925.2029.341.camel@i7.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307109833.2487.0.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-29 at 01:12 +0100, David Woodhouse wrote:
> Patches 1-6 applied to iommu-2.6.git. Please test. Thanks.

This is all now in Linus' tree for 3.0-rc2, and since you included
'Cc: stable' in the commit comments it should magically turn up in a
stable tree near you.

I will leave you to deal with the question of how to mark 'old' kernels
as actually having had later bugs fixed.

-- 
dwmw2




