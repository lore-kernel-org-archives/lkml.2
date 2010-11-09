Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab0KIWIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:08:40 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31237 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002Ab0KIWIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:08:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANJU2Ux5LcZK/2dsb2JhbACiJnK9RYVKBI9l
Date: Wed, 10 Nov 2010 09:08:33 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 4/6] fs: d_delete change
Message-ID: <20101109220833.GG3246@amd>
References: <20101109124610.GB11477@amd>
 <20101109130133.GE11477@amd>
 <20101109162516.GB6217@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109162516.GB6217@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 11:25:16AM -0500, Christoph Hellwig wrote:
> The patch looks fine to me, and I'm also fine with merging it ASAP.
> But the patch subject and commit message are not very descriptive.

How is the commit message not descriptive? The first sentence
summarises exactly what the change does. The last says why it
is required. In the middle are some details.

