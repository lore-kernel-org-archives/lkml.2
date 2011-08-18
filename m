Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab1HRRxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:53:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab1HRRxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:53:30 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org
Subject: Re: Updated direct IO optimization patchkit v2
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 18 Aug 2011 13:53:16 -0400
In-Reply-To: <1312259893-4548-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Mon, 1 Aug 2011 21:38:02 -0700")
Message-ID: <x4939gysj1v.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Various micro optimizations of the block direct IO path.
>
> This addresses all review comments and adds an additional prefetch
> optimization that gives another about 0.3% in a large macro benchmark.
> Overall the patchkit is worht about 2.2% in the same macro benchmark.
>
> I also ported it to current mainline, resolving some conflicts with
> hch's recent changes to direct-io.

Hi, Andi,

If you get rid of the unlikely I pointed out in patch 11 and address my
question on patch 6 (about always_inline) and repost, I'll ack the
series.  I was hoping hch or Jens would chime in on patch 10, but it
seems they're busy.

Cheers,
Jeff
