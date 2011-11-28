Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab1K1Ee4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 23:34:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:55231 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab1K1Eez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 23:34:55 -0500
Message-ID: <1322454868.23348.38.camel@pasglop>
Subject: Re: [V2 PATCH 00/62] highmem: remove the second argument of
 kmap_atomic/kunmap_atomic
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tony Breeds <tbreeds@au1.ibm.com>
Date: Mon, 28 Nov 2011 15:34:28 +1100
In-Reply-To: <1322432495.23348.1.camel@pasglop>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
	 <1322432495.23348.1.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 09:21 +1100, Benjamin Herrenschmidt wrote:
> On Sun, 2011-11-27 at 13:26 +0800, Cong Wang wrote:
> > V1: https://lkml.org/lkml/2011/1/30/13
> > 
> > V1->V2: Split patches and rebase them to the latest linus tree.
> 
> I'm not too fan of the split myself... 62 patches is just plain crazy.
> However, no obvious objection from the patches themselves (at least the
> ones affecting powerpc), though I haven't had a chance to test them yet.

So Tony tested for me (thanks !) and it looks all fine.

For the powerpc parts

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.


