Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab2BIWZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:25:34 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37166 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758626Ab2BIWZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:25:29 -0500
Date: Thu, 9 Feb 2012 22:25:11 +0000
From: Will Deacon <will.deacon@arm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the irqdomain tree with the arm tree
Message-ID: <20120209222508.GA5789@mudshark.cambridge.arm.com>
References: <20120209151413.0dfec71771dd156843c0f4fa@canb.auug.org.au>
 <CACxGe6sskg2t0QtOgWCKvYFdqWbsM4Cbdt05ZaNCLzrdNd6iLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6sskg2t0QtOgWCKvYFdqWbsM4Cbdt05ZaNCLzrdNd6iLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 06:29:10AM +0000, Grant Likely wrote:
> The context fixup looks correct to me.  I'll test the current
> linux-next tree when I get a chance (I'm at a conference at the
> moment).

Likewise - today's next looks fine but I don't have any platforms to hand
for testing.

Will
