Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096Ab1LPPaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 10:30:16 -0500
Received: from 8bytes.org ([88.198.83.132]:51502 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759955Ab1LPPaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 10:30:12 -0500
Date: Fri, 16 Dec 2011 16:30:11 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: manual merge of the iommu tree with the
	pci-current tree
Message-ID: <20111216153011.GC28302@8bytes.org>
References: <20111216133026.8bac235bb8495cfd8669b761@canb.auug.org.au> <20111216085247.GA28302@8bytes.org> <20111216071840.6e06864f@jbarnes-vaio.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111216071840.6e06864f@jbarnes-vaio.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 07:18:40AM -0800, Jesse Barnes wrote:
> Yeah, this is probably my fault; pri-changes has drifted relative to my
> linux-next branch.  I'll rebase it onto linux-next and push again.
> That should fix things.

Please don't rebase. I already pulled in the changes and don't want to
rebase that :) Can you just merge the pri-changes branch into your
linux-next branch?


	Joerg

